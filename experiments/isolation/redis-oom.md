# Redis Slowlog OOM Injection

We use `cgroup` to enforce a memory limit of 256 MB on the orbit task, and inject a memory allocation of 512 MB in orbit task. `Cgroup` will trigger an OOM kill on the task that goes over the memory limit.

We force the triggering of the fault in the orbit task, so that any request will cause the memory overuse issue.

## Preparing `cgroup`

Create a `cgroup` and set resource limit by running
```bash
cgdelete -g memory:/memorylimit 2> /dev/null
cgcreate -g memory:/memorylimit
cgset -r memory.limit_in_bytes=$((256*1024*1024)) memorylimit
```

## Producing OOM

Start Redis server by running

```bash
module load redis/oom
redis-server
```

In another tmux pane, start the Redis client:
```bash
module load redis/oom
redis-cli
```
and run a simple command in Redis client:
```
set foo bar
```

The Redis server side will show an OOM kill on the redis task, but the server is still functional. Try Redis command
```
get foo
```
The Redis client can still correctly return the `bar` as the output.

Stop everything by CTRL-C on the Redis server and CTRL-D on the Redis client, and run
```bash
pkill -9 redis-server
module unload redis
```
