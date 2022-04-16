# Orbit call (async)

This experiment measures the latency of `orbit_call_async` with respect to the size of orbit area, as mentioned in Figure 8.

## Running the experiment (30s)

Run the experiment by running `./run.sh` in this directory. It runs each data point for 20 times, and it takes in total about 30s.

## Analyzing results

Plot the figure by running `./plot.sh`.

The VM does not contain GUI environment, so to view the figure, it needs to be copied out first. Shutdown the VM, then on the host machine, mount and copy:
```bash
m
sudo cp mount-point.dir/root/orbit/experiments/micro-call/figure.pdf .
```
