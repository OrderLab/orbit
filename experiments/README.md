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

## Troubleshooting

- **1 Warning message about `rss-counter`**

During the experiment, you may see some warning messages from the kernel like
the following. This is showing up when an orbit process exits, but due to some
implementation error the stats was not correctly updated. You can safely ignore them.
```
[   41.754599] BUG: Bad rss-counter state mm:00000000b1f76ba0 type:MM_ANONPAGES val:131072
```
