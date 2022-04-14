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
# matplotlib.rc('text', usetex=True)

parser = argparse.ArgumentParser()
parser.add_argument('-o', '--output', help="path to output image file")
parser.add_argument('input', help="input data file")

def plot_line(ax, df, label, marker, color):
    ax.plot(df.index.values, df.values, label=label,
            marker=marker, color=color, markersize=4, linewidth=2, zorder=3)

def plot(args):
    df = pd.read_csv(args.input, index_col=0)
    vanilla_df = df['vanilla_qps']
    orbit_df = df['orbit_qps']
    fork_df = df['fork_qps']

    vanilla_mean = vanilla_df.mean()
    orbit_mean = orbit_df.mean()
    fork_mean = fork_df.mean()

    print(vanilla_mean, orbit_mean, fork_mean, 1 - (orbit_mean / vanilla_mean), orbit_mean / fork_mean)

    figure, ax = plt.subplots(figsize=(4.6, 2.3))
    plot_line(ax, vanilla_df, 'vanilla (unsafe) dl detector', '^', '#A00000')
    plot_line(ax, orbit_df, 'orbit (safe) dl detector ', 'o', '#00A000')
    plot_line(ax, fork_df, 'fork (safe) dl detector ', '+', '#041D37')

    ax.legend(loc='lower center', ncol=1, frameon=True, edgecolor='black', fontsize=9,
            bbox_to_anchor=(0.5, 0.35), columnspacing=1.0)
    ax.grid(axis='y', linestyle='-', lw=0.3, zorder=0)
    ax.set_ylabel('Throughput (QPS)', fontsize=10)
    ax.set_xlabel('Time (s)', fontsize=10)
    ax.set_ylim(bottom=0)
    ax.yaxis.set_major_locator(MultipleLocator(800))

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
