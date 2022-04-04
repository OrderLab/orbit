# Experiments

We provide scripts for the following list of experiments mentioned in the paper. Click on each experiment's link for its usage.

## Fault Isolation (section 5.4)

We provide a set of cases to show the effect of isolation by orbit. Click on each case's link to see the usage.

Some of the case would require two or more operations running at the same time. It is recommended to use `tmux` to create a split view of terminals for better demonstration purpose.

- Real-world cases
  - [Apache proxy balancer segfault](isolation/apache-segfault.md)
  - [Nginx WebDAV segfault](isolation/nginx-segfault.md)
  - [Redis Slowlog memory leak](isolation/redis-memleak.md)

## Performance Overhead (section 5.5)

- [Throughput](throughput/README.md)
