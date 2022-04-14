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
            marker=marker, markersize=4, color=color, linewidth=2, zorder=3)

def plot(args):
    df = pd.read_csv(args.input, index_col=0)
    async_orbit_df = df['async_orbit_qps']
    sync_orbit_df = df['sync_orbit_qps']

    figure, ax = plt.subplots(figsize=(4.6, 2.3))
    plot_line(ax, sync_orbit_df, 'orbit_call (sync) to dl detector', '|', '#A00000')
    plot_line(ax, async_orbit_df, 'orbit_call_async to dl detector ', 'o', '#00A000')

    ax.legend(loc='lower center', ncol=1, frameon=True, edgecolor='black', fontsize=9, 
            bbox_to_anchor=(0.6, 0.1), columnspacing=1.0)
    ax.grid(axis='y', linestyle='-', lw=0.3, zorder=0)
    ax.set_ylabel('Throughput (QPS)', fontsize=10)
    ax.set_xlabel('Time (s)', fontsize=10)
    ax.set_ylim(bottom=0)
    ax.yaxis.set_major_locator(MultipleLocator(1000))

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
