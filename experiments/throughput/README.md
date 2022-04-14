# Overhead: Throughput

This experiments measures the overhead on throughput for all 8 systems, and reproduces Figure 9.

## Running the experiment

We provide a script to run systems in batch. For example, run the following command to run 7 systems.
```bash
./run_batch.sh leveldb nginx proxy rdb slowlog varnish watchdog
```

Note that MySQL require a different kernel version. To run MySQL workload, shutdown the VM, and start the VM via `r formysql` on the host, and then in the VM:
```bash
./run_batch.sh mysql
```

### Repeat times

By default, the `run_batch.sh` script repeat for only 1 time. To run it for more time (e.g. 3 times), insert an integer argument as the first argument:
```bash
./run_batch.sh 3 [systems...]
```

### Expected running time

Below shows the expected time of each system with `repeat` of 1. The first 7 systems (which can run using the same kernel) takes about 25min.

| System   | Approx. time (min) |
| ----     | ---- |
| leveldb  | 2.5  |
| nginx    | 4    |
| proxy    | 2.5  |
| rdb      | 2    |
| slowlog  | 4.5  |
| varnish  | 4.5  |
| watchdog | 4.5  |
| mysql    | 4.5  |

## Analyzing results

Generate figure by running `./plot.sh`.

The VM does not contain GUI environment, so to view the figure, it needs to be copied out first. Shutdown the VM, then on the host machine, mount and copy:
```bash
m
cp mount-point.dir/root/orbit/experiments/throughput/figure.pdf .
```

## Cleanup logs

To cleanup logs, run
```bash
rm */*.{out,err,log}
```
