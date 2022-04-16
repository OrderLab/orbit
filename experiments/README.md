# Experiments (~4 h)

We provide scripts for the following list of experiments mentioned in the paper. Click on each experiment's link for its usage.

## Microbenchmark (section 5.2)

- [Orbit call (async)](micro-call) (~30 s)

## Fault Isolation (section 5.4)

We provide a set of cases to show the effect of isolation by orbit. Click on each case's link to see the usage.

Some of the case would require two or more operations running at the same time. It is recommended to use `tmux` to create a split view of terminals for better demonstration purpose.

- Real-world cases
  - [Apache proxy balancer segfault](isolation/apache-segfault.md) (~5 min human)
  - [Nginx WebDAV segfault](isolation/nginx-segfault.md) (~3 min human)
  - [Redis Slowlog memory leak](isolation/redis-memleak.md) (~3 min human)
- Injection cases
  - [Apache lock watchdog diagnosis](isolation/watchdog-diagnosis.md) (~3 min human)
  - [Redis RDB segfault](isolation/rdb-segfault.md) (~3 min human)
  - [Redis Slowlog OOM](isolation/redis-oom.md) (~3 min human)
  - [Redis Slowlog CPU hogging](isolation/redis-cpu-hog.md) (~3 min human)

## Performance Overhead (section 5.5)

- [Throughput](throughput) (~2.5 h)
- [Fork vs Vanilla vs Orbit](fork-ob-orig) (~30 min)
- [Sync vs Async orbit calls](async-sync) (~20 min)

## Known issues

**1 Warning message about `rss-counter`**

During the experiment, you may see some warning messages from the kernel like
the following. This is showing up when an orbit process exits, but due to some
implementation error the stats was not correctly updated. You can safely ignore them.
```
[   41.754599] BUG: Bad rss-counter state mm:00000000b1f76ba0 type:MM_ANONPAGES val:131072
```

**2 Flaky Orbit version Redis RDB background save stuck**

When Redis RDB is saving an RDB file to disk, you should be able to see the four following lines:
```
269:M 16 Apr 01:31:45.120 * Background saving started by pid 287
287:C 16 Apr 01:31:45.123 * DB saved on disk
287:C 16 Apr 01:31:45.123 * RDB: 0 MB of memory used by copy-on-write

269:M 16 Apr 01:31:45.125 * Background saving terminated with success
```

However, due to a bug in implementation, the fourth line may sometimes be
missing. When you noticed a missing fourth line, kill the Redis server by
CTRL-C on it, and run `pkill -9 redis-server`. And then restart the experiment.

**3 Flaky Orbit version Varnish segfault issue**

When running the varnish performance test, due to a bug in implementation,
sometimes the varnish server will segfault. Press CTRL-C on the running script
and re-run the experiment.
