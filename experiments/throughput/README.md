# Overhead: Throughput

This experiments measures the overhead on throughput for all 8 systems, and reproduces Figure 9.

## Running the experiment

We provide a script to run systems in batch. For example, run the following command to run the 5 systems.
```bash
./run_batch.sh leveldb nginx proxy slowlog watchdog
```

Note that MySQL require a different kernel version. To run MySQL workload, shutdown the VM, and start the VM via
```bash
r formysql
```
on the host, and then in the VM:
```bash
./run_batch.sh mysql
```

***Please also see [Known issues](#known-issues) section before running the experiments.***

### Repeat times

By default, the `run_batch.sh` script only repeat for 1 time. To run it for
more time (we repeated for 5 times in the paper), insert an integer argument as
the first argument:
```bash
./run_batch.sh 5 [systems...]
```

### Expected running time

Below shows the expected time of each system running for once. The first 7
systems (which can run using the same kernel) takes about 25min. Repeating all
experiments for 5 times takes about 2.5 hours in total.

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
sudo cp mount-point.dir/root/orbit/experiments/throughput/figure.pdf .
```

## Known issues

As mentioned in the [Known issues](../README.md#known-issues) in the upper
directory, there are some flaky bugs in Redis RDB and Varnish. See the upper
directory for the buggy behaviors.

Therefore, you may want to run the 5 systems first:
```bash
./run_batch.sh [times] leveldb nginx proxy slowlog watchdog
```

Then `cd` into `rdb/` and `varnish/` in this directory to run multiple runs
respectively and monitor the results:
```bash
# suppose we are in experiments/throughput/
cd rdb/  # or `cd varnish/`
./run.sh -n 1
./run.sh -n 2
...
./run.sh -n 5
```
Here each line will only repeat once, and when there is buggy error behavior,
you can restart that single round. The `-n` specifies which log file to (re)write to.
You will see result files naming similar to `res-orbit-2.log` when running with `-n 2`.

And finally shutdown the VM and start the VM again with the kernel for MySQL
with `r formysql`, and then `cd` into the `mysql/` folder in this directory,
and run multiple times.
```bash
# suppose we are in experiments/throughput/
cd mysql/
./run.sh 5
```

## Cleanup logs

To cleanup all previous results, run the following command in this directory.
```bash
rm */*.{out,err,log}
```
