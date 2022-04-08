# Redis Slowlog memory leak case

Original issue: https://github.com/redis/redis/issues/4323

Description: A possible race condition (TOCTOU bug) on refcount between the asynchronous `lazyfree` thread and the SLOWLOG command can cause memory leak.

## Reproducing original issue

Start the redis server that reverted the fixes. We have injected 10,000 microseconds delay to the code to make it easier to reproduce.
```bash
module load redis/memleak
redis-server
```

In another tmux pane, start the redis client and feed in the payload commands in the current directory:
```bash
cd experiments/isolation/
module load redis/memleak
redis-cli < redis-memleak-payload
```

> Explanation of the payload file:
> ```
> config set slowlog-log-slower-than 0   # set to log all operations in slowlog
> set foo bar           # "bar" string object will be added to both the dict and the slowlog
> object refcount foo   # refcount should be 2 (1 for 'foo' key, 1 in slowlog entry)
> FLUSHALL ASYNC        # (async) refcount--
> SLOWLOG reset         # (sync)  refcount--
> ```
> and the last two refcount-- have a TOCTOU bug.

The output that indicates memory leak is
```
bar obj dec
(... DB saved on disk ...)
bar obj dec
bar obj dec
```
with no text showing "bar obj free".

Stop redis by CTRL-C on the running `redis-server` and then `module unload redis` in every tmux pane.

## Isolation with orbit

Start the orbit version or redis server.
```bash
module unload redis
module load redis/slowlog-delay
redis-server
```

In another tmux pane, start the redis client and feed in the payload:
```bash
module load redis/slowlog-delay
redis-cli < redis-memleak-payload
```

The expected output that indicates successful memory deallocation will be
```
bar obj dec
bar obj dec
(... DB saved on disk ...)
bar obj free
```
We can see there is a "bar obj free" in the output.

Stop redis by CTRL-C on the running `redis-server` and then
```bash
killall -9 redis-server
module unload redis
```
