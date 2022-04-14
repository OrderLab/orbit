#!/usr/bin/env python3

import sys
import pandas as pd
from datetime import datetime
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.ticker import MultipleLocator
import numpy as np
import argparse
import matplotlib
from matplotlib import cm

parser = argparse.ArgumentParser()
parser.add_argument('-o', '--output', help="path to output image file")
parser.add_argument('input', help="path to input data file")

#matplotlib.rcParams['pdf.fonttype'] = 42
#matplotlib.rcParams['ps.fonttype'] = 42

def hatch_bar(ax, df):
    bars = ax.patches
    hatches = '-\\/.-+o'
    hatch_repeats = 4 
    all_hatches = []
    for h in hatches:
        all_hatches.extend([h * hatch_repeats] * len(df))
    for bar, hatch in zip(bars, all_hatches):
        bar.set_hatch(hatch)

def plot_overhead(df):
    vanilla = df['Vanilla']
    orbit = df['Orbit']
    relative_vanilla = vanilla / vanilla
    relative_orbit = orbit / vanilla
    print(1 - relative_orbit)
    print(1 - relative_orbit.median())

    figure, ax = plt.subplots(figsize=(5, 2))
    ind = np.arange(len(relative_orbit))
    width = 0.4
    vanilla_bars = ax.bar(ind, relative_vanilla.values, width - 0.03, bottom=0, label='Vanilla', color='#a6dc80')
    orbit_bars = ax.bar(ind + width, relative_orbit.values, width - 0.03, bottom=0, label='Orbit', color='#98c8df')
    ax.set_xticks(ind + 0.5 * width)
    ax.set_xticklabels(df.index.values, rotation=0)
    ax.set_ylim(0, 1.1)
    hatch_bar(ax, relative_orbit)
    ax.set_yticks(np.arange(0, 1.1, 0.2))

    # for p, v in zip(vanilla_bars, vanilla.values):
    #     height = p.get_height()
    #     ax.text(p.get_x() + p.get_width() / 2., 1.05 * height, '%.1f' % round(v),
    #             ha='center', va='bottom')

    ax.legend(loc='lower left', bbox_to_anchor=(0., 0.92), frameon=False, fontsize=9, ncol=3)
    ax.set_ylabel("Normalized thput")
    ax.set_xlabel("Task")
    for tick in ax.get_xticklabels():
        tick.set_rotation(0)
    plt.tight_layout()
    if args.output:
        plt.savefig(args.output, bbox_inches='tight', pad_inches=0)
    plt.show()

if __name__ == '__main__':
    args = parser.parse_args()
    if not args.input:
        sys.stderr.write('Must specify input data file\n')
        sys.exit(1)
    df = pd.read_csv(args.input, index_col=0)
    plot_overhead(df)

