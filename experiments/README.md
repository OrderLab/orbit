# Experiments

We provide scripts for the following list of experiments mentioned in the paper. Click on each experiment's link for its usage.

## Microbenchmark

- [Orbit call (async)](micro-call)

## Fault Isolation (section 5.4)

We provide a set of cases to show the effect of isolation by orbit. Click on each case's link to see the usage.

Some of the case would require two or more operations running at the same time. It is recommended to use `tmux` to create a split view of terminals for better demonstration purpose.

- Real-world cases
  - [Apache proxy balancer segfault](isolation/apache-segfault.md)
  - [Nginx WebDAV segfault](isolation/nginx-segfault.md)
  - [Redis Slowlog memory leak](isolation/redis-memleak.md)
- Injection cases
  - [Apache lock watchdog diagnosis](isolation/watchdog-diagnosis.md)
  - [Redis RDB segfault](isolation/rdb-segfault.md)
  - [Redis Slowlog OOM](isolation/redis-oom.md)
  - [Redis Slowlog CPU hogging](isolation/redis-cpu.md)

## Performance Overhead (section 5.5)

- [Throughput](throughput)
- [Fork vs Vanilla vs Orbit](fork-ob-orig)
- [Sync vs async orbit calls](async-sync)
