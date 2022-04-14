# Fork vs Vanilla vs Orbit

This experiment compares fork, vanilla, and orbit versions of MySQL by running a user workload.

## Running the experiment

This experiment requires running another version of kernel. Start the VM by running `r formysql`.

To run the experiment, run `./run.sh` in this directory.

### Repeat times

By default, the `run.sh` script repeat for only 1 time. Repeating 1 round takes about 4 min. To run it for more time (e.g. 3 times), run with argument:
```bash
./run.sh 3
```

## Analyse results

Generate figure by running `./plot.sh`.

The VM does not contain GUI environment, so to view the figure, it needs to be copied out first. Shutdown the VM, then on the host machine, mount and copy:
```bash
m
cp mount-point.dir/root/orbit/experiments/fork-ob-orig/figure.pdf .
```
