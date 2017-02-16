"""
Code to compare different months of KMOS
darks and look for correlations.

Created By: Laurence Routledge
Created On: 29/11/2016
Last Modified: 30/11/2016
"""

import os

import numpy as np
import matplotlib.pyplot as plt

os.chdir("/Data/routledge/KMOS/data/sept")

means_first = np.load("means_first.npy")
var_first = np.load("var_first.npy")

#os.chdir("/Data/routledge/KMOS/data/oct")
means_second = np.load("means_second.npy")
var_second= np.load("var_second.npy")

plt.plot(means_first[:1000, :1000], means_second[:1000, :1000], 'x')
plt.xlim(-60,60)
plt.ylim(-60,100)
plt.xlabel("mean first half")
plt.ylabel("mean second half")
plt.title("Correlation of Pixel Means within September")
os.chdir("/Data/routledge/KMOS/data/sept")

plt.savefig("sept-correlation.png")

plt.show()
