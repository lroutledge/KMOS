import os
from glob import glob

import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits

os.chdir("/Data/routledge/KMOS/data/oct")

means = np.load("means.npy")
var = np.load("var.npy")

sds=np.sqrt(var)
means_sorted = means.reshape(2048*2048)
means_sorted = sorted(means_sorted)

fits_files = glob("*.fits")         #gets all the fits files
max_range = len(fits_files)

i_vals, j_vals = [],[]#[1852],[1536]

for val in range(1):
    i_vals.append(np.where(means == means_sorted[val+2])[0])
    j_vals.append(np.where(means == means_sorted[val+2])[1])

all_data = []
for j in range(max_range):
    print j
    data = fits.getdata(fits_files[j])
    im_data = []

    for i in range(len(i_vals)):
        im_data.append(data[i_vals[i],j_vals[i]])
    all_data.append((im_data - means[i_vals[i], j_vals[i]]) / sds[i_vals[i], j_vals[i]])
 #   all_data.append(im_data)

all_data = np.array(all_data)

plt.figure()
for k in range(len(i_vals)):
    dat = all_data[:,k]
    bins = np.arange(-100, 100, 1)
    hist, bin_edges = np.histogram(dat, bins)
    plt.plot(bin_edges[:-1]+0.5, hist)

os.chdir("../..")

plt.show()
