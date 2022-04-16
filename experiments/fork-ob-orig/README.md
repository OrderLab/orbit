# Fork vs Vanilla vs Orbit

This experiment compares fork, vanilla, and orbit versions of MySQL by running a user workload.

## Running the experiment

This experiment requires running another version of kernel. Start the VM by running `r formysql`.

To run the experiment, run `./run.sh` in this directory.

### Repeat times

By default, the `run.sh` script repeat for only 1 time, taking about 6 min. To
run it for multiple times (we repeated for 5 times in the paper), run with an
argument as follows.
```bash
./run.sh 5
```

## Analyse results

Generate figure by running `./plot.sh`.

The VM does not contain GUI environment, so to view the figure, it needs to be copied out first. Shutdown the VM, then on the host machine, mount and copy:
```bash
m
sudo cp mount-point.dir/root/orbit/experiments/fork-ob-orig/figure.pdf .
```
