#!/usr/bin/env python3

import sys
import os
import pandas as pd
from datetime import datetime
import matplotlib.pyplot as plt
from matplotlib.ticker import MultipleLocator
import numpy as np
from matplotlib import cm
import argparse
import matplotlib

#matplotlib.rcParams['pdf.fonttype'] = 42
#matplotlib.rcParams['ps.fonttype'] = 42
#matplotlib.rc('text', usetex=True)

parser = argparse.ArgumentParser()
parser.add_argument('-o', '--output', help="path to output image file")
parser.add_argument('input', help="input data file")

def human_size_format(num):
    for unit in 'KMGT':
        if num < 1024:
            return f'{num}{unit}B'
        if num % 1024 != 0:
            raise ValueError(f'num {num} is not divisible by 1024')
        num //= 1024
    return f'{num}PB'

def plot(args):
    df = pd.read_csv(args.input)

    figure, ax = plt.subplots(figsize=(4.6, 2.5))

    ind = np.arange(len(df))
    ax.plot(ind, df['Time(us)'].values, label='orbit_call_async', 
            marker='s', color='#00008B', linewidth=2, zorder=3)
    ax.set_yscale('log')
    ax.set_xticks(ind[::3])
    ax.set_xticklabels(map(human_size_format, df['Size(KB)'].values[::3]))

    ax.legend(loc='best', ncol=1, frameon=True, edgecolor='black', fontsize=9, 
            columnspacing=1.0)
    ax.grid(axis='y', linestyle='--', zorder=0)
    ax.set_ylabel('Latency (us)', fontsize=10)
    ax.set_xlabel('State size', fontsize=10)
    #  ax.set_ylim(bottom=0)

    figure.tight_layout()
    if args.output:
        ax.margins(0,0)
        plt.savefig(args.output, bbox_inches='tight', pad_inches=0)
    plt.show()

if __name__ == '__main__':
    args = parser.parse_args()
    if not args.input or not os.path.isfile(args.input):
        sys.stderr.write("Input file " + args.input + " does not exist\n")
        sys.exit(1)
    plot(args)
