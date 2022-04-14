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

asy_data = parse('incone-orbit-16-report-')
syn_data = parse('incone-sync-16-report-')

with open('async-sync-orbit.csv', 'w') as f:
    writer = csv.DictWriter(f, fieldnames=['time', 'async_orbit_qps', 'sync_orbit_qps'])
    writer.writeheader()

    for i, (asy, syn) in enumerate(zip(asy_data, syn_data)):
        writer.writerow({ 'time': (i+1)*timegap, 'async_orbit_qps': asy, 'sync_orbit_qps': syn })
