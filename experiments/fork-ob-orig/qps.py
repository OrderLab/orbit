#!/usr/bin/env python3

import csv
from statistics import mean
from os import listdir

# 2 sec gap between two data points
timegap = 2

def parse(prefix):
    groups = []
    for filename in listdir('.'):
        if filename.startswith(prefix):
            with open(filename) as f:
                ename = f.readline()
                lines = [int(line.strip()) for line in f.readlines()]
            groups.append(lines)
    new_groups = []
    for nums in groups:
        new_nums = []
        last_num = 0
        for x in nums:
            new_nums.append((x - last_num) / timegap)
            last_num = x
        new_groups.append(new_nums)
        assert(len(new_nums) == 60)
    new_groups = list(map(mean, zip(*new_groups)))
    return new_groups

orbit = parse('incone-orbit-8-report-')
orig = parse('incone-orig-8-report-')
fork = parse('incone-fork-8-report-')

with open('orbit-comparison.csv', 'w') as f:
    writer = csv.DictWriter(f, fieldnames=['time', 'vanilla_qps', 'orbit_qps', 'fork_qps'])
    writer.writeheader()

    for i, (va, ob, fo) in enumerate(zip(orig, orbit, fork)):
        writer.writerow({ 'time': (i+1)*timegap, 'vanilla_qps': va,
                          'orbit_qps': ob, 'fork_qps': fo })
