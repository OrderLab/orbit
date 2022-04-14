# Redis Slowlog CPU Hogging Injection

We use `cgroup` to enforce a CPU time limit of 10%, and inject a 10s busy loop in orbit task.

We force the triggering of the fault in the orbit task, so that any request will cause the memory overuse issue.

## Preparing `cgroup`

Create a `cgroup` and set resource limit by running
```bash
cgdelete -g cpu:/cpulimit 2> /dev/null
cgcreate -g cpu:/cpulimit
cgset -r cpu.cfs_period_us=$((1000*1000)) cpulimit
cgset -r cpu.cfs_quota_us=$((1000*100)) cpulimit
```

## Producing CPU Hogging

Start Redis server by running

```bash
module load redis/cpu-hog
redis-server
```

In another tmux pane, start the Redis client:
```bash
module load redis/cpu-hog
redis-cli
```
and run a simple command in Redis client:
```
set foo bar
```

Start the `top` command, and we can see that the total system CPU usage should be only about 10%.

Stop everything by CTRL-C on the Redis server and CTRL-D on the Redis client, and run
```bash
pkill -9 redis-server
module unload redis
```
