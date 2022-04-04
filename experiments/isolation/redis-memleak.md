# Redis Slowlog memory leak case

Original issue: https://github.com/redis/redis/issues/4323

Description: A possible race condition between the asynchronous `lazyfree` thread and the SLOWLOG command can cause memory leak.

## Reproducing original issue

Start the redis server that reverted the fixes. We have injected 10,000 microseconds delay to the code to make it easier to reproduce.
```bash
module load redis/memleak
redis-server
```

On another tmux pane, start the redis client:
```bash
redis-cli
```
and type in the payload one by one (words after '#' are comments)
```
config set slowlog-log-slower-than 0
set foo bar
object refcount foo   # refcount should be 2 (1 for 'foo' key, 1 in slowlog entry)
FLUSHALL ASYNC        # (in thread) refcount-- or free
SLOWLOG reset         # (sync)      refcount-- or free
```

The output that indicates memory leak is
```
bar obj dec
(... DB saved on disk ...)
bar obj dec
bar obj dec
refcnt 0
```
with no text showing "bar obj free".

Stop redis by CTRL-C on the running `redis-server`.

## Isolation with orbit

Start the orbit version or redis server.
```bash
module unload redis
module load redis/slowlog-delay
redis-server
```

Run the same previous payload, and the expected output that indicates successful memory deallocation will be
```
bar obj dec
bar obj dec
(... DB saved on disk ...)
bar obj free
refcnt 1
```

Stop redis by CTRL-C on the running `redis-server` and running `killall redis-server` to also kill orbit instances.
