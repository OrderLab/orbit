# Redis RDB segfault injection

We manually inject a null-pointer dereference bug every 3 RDB background save calls. We will show that the main part of Redis can survive such faults even if RDB component fails.

## Producing faults

In one tmux pane, start the Redis server.
```bash
module load redis/rdb-fault
redis-server
```

In another tmux pane, start the Redis client.
```bash
module load redis/rdb-fault
redis-cli
```

Then in the Redis client prompt, trigger three background saves.
```
bgsave
bgsave
bgsave
```

At the last run of `bgsave`, there will be a segmentation fault showing up in the Redis server pane, but the server is still running. At this time, try inserting a KV pair to Redis:
```
set foo bar
```
Redis will show the following error message:
```
(error) MISCONF Redis is configured to save RDB snapshots, but it is currently not able to persist on disk. Commands that may modify the data set are disabled, because this instance is configured to report errors during writes if RDB snapshotting fails (stop-writes-on-bgsave-error option). Please check the Redis logs for details about the RDB error.
(error) ...
```
Redis by default protects any modification to the in-memory dictionary when an error occurs during RDB save. The orbit version provides the same level of isolation as the original fork version, and also utilizes this protection mechanism. Furthermore, Redis snapshots less pages compared to fork, as mentioned in t6 in Table 6.

At this point, we can make another successful `bgsave` and try to insert a KV pair again:
```
bgsave
set foo bar
```
This time the above two commnads will finish successfully.

Stop Redis by CTRL-C on the Redis server and CTRL-D on the Redis client, and then run
```bash
pkill -9 redis-server
module unload redis
```
