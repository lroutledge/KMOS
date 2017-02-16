"""
Code to analyse KMOS data in order to determine
the underlying distribution of the pixel values.

Created By: Laurence Routledge
Created On: 15/11/2016
Last Modified: 30/11/2016
"""

import os
from glob import glob

import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits
from scipy.interpolate import spline

month='oct'

os.chdir("/Data/routledge/KMOS/data/oct")    #directory containing the data
'''
def use_pixel_range(lower, upper):
    all_data = []
    
    for i in range(max_range):
        data = fits.getdata(fits_files[i])[lower:upper, lower:upper]
        all_data.append((data - means[lower:upper, lower:upper]) /
                        sds[lower:upper, lower:upper])

    all_data = np.array(all_data)

    plt.figure()
    for i in range(upper - lower):
        print i
        for j in range(upper - lower):
            dat = all_data[:,i,j]
            bins = np.arange(-5.25, 5.75, 0.75)
            hist, bin_edges = np.histogram(dat,bins)
            plt.plot(bin_edges[:-1]+0.375, hist)
            
    plt.title("Histogram showing spread of 'true' zero values for single pixels")
    plt.xlabel("Pixel value")
    plt.ylabel("Count")
    plt.ylim(0,70)
    plt.savefig("../../images/"+str(month)+"true-zeros.png")

    plt.show()

def use_pixel_values(i_vals, j_vals, extension):
    all_data = []
    for j in range(max_range):
        print j
        data = fits.getdata(fits_files[j])
        im_data=[]

        for i in range(len(i_vals)):
            im_data.append(data[i_vals[i],j_vals[i]])
        all_data.append((im_data - means[i_vals[i], j_vals[i]]) /
                        sds[i_vals[i], j_vals[i]])

    all_data = np.array(all_data)
    
    plt.figure()
    for k in range(len(i_vals)):
        dat = all_data[:,k]
        bins = np.arange(-5, 6, 1)
        hist, bin_edges = np.histogram(dat,bins)
        plt.plot(bin_edges[:-1]+0.5, hist)

    plt.title("Histogram showing spread of 'true' zero values for single "+str(extension)+" pixels")
    plt.xlabel("Pixel value")
    plt.ylabel("Count")
    plt.ylim(0,70)
    plt.savefig("../../images/"+str(month)+"true-zeros-"+str(extension)+".png")
        
    plt.show()
'''

fits_files = glob("*.fits")         #gets all the fits files
max_range = len(fits_files)

print "Number of fits files: ", max_range

#load in the mean and variance data (see 'kmos.py')
means = np.load("means.npy")
var = np.load("var.npy")
sds = np.sqrt(var)                  #convert to standard deviation

means_ref = np.concatenate((means[0:4,0:2047].flatten(), means[2044:2047,0:2047].flatten(),\
            means[4:2044,0:4].flatten(), means[4:2044,2044:2047].flatten()))

sds_ref = np.concatenate((sds[0:4,0:2047].flatten(), sds[2044:2047,0:2047].flatten(),\
            sds[4:2044,0:4].flatten(), sds[4:2044,2044:2047].flatten()))

sds_sorted = sds.reshape(2048*2048)
sds_sorted = sorted(sds_sorted)

i_high, j_high, i_low, j_low, i_med, j_med = [], [], [], [], [], []

for val in range(100):
    i_high.append(np.where(sds == sds_sorted[-50000-val])[0])
    j_high.append(np.where(sds == sds_sorted[-50000-val])[1])
    i_low.append(np.where(sds == sds_sorted[val+10])[0])
    j_low.append(np.where(sds == sds_sorted[val+10])[1])
    i_med.append(np.where(sds == sds_sorted[2100000+val])[0])
    j_med.append(np.where(sds == sds_sorted[2100000+val])[1])
    
i_rand = np.random.randint(5, 2045, 100)
j_rand = np.random.randint(5, 2045, 100)

##Plot of standard deviations
    
bins = np.arange(0,63000,0.01)
hist, bin_edges = np.histogram(sds_sorted, bins)
plt.figure()
plt.semilogy(bin_edges[:-1]+0.05, hist, label='all_data')
plt.xlim(0,40)
plt.xlabel("Standard Deviation")
plt.ylabel("Log Count")
plt.title("Histogram of Standard Deviations of Pixels")
plt.savefig("../../images/"+str(month)+"st-devs-all.png")

bins_ref = np.arange(0,66,0.1)
hist_ref,bin_edges_ref = np.histogram(sds_ref, bins_ref)
plt.figure()
plt.semilogy(bin_edges_ref[:-1]+0.05, hist_ref, label='ref_data')
plt.xlim(0,40)
plt.xlabel("Standard Deviation")
plt.ylabel("Log Count")
plt.title("Histogram of Standard Deviations of Reference Pixels")
plt.savefig("../../images/"+str(month)+"st-devs-ref.png")

##Plot of means

bins_all = np.arange(-600,10000,0.1)
hist_all, bin_edges_all = np.histogram(means, bins_all)
plt.figure()
plt.semilogy(bin_edges_all[:-1]+0.05, hist_all, label='all data')
plt.xlim(-60,120)
plt.xlabel("Mean")
plt.ylabel("Count")
plt.title("Histogram of Means of Pixels")
plt.savefig("../../images/"+str(month)+"means-all.png")

bins_ref = np.arange(-400,610,0.5)
hist_ref, bin_edges_ref = np.histogram(means_ref, bins_ref)
plt.figure()
plt.semilogy(bin_edges_ref[:-1]+0.25, hist_ref, label='ref pixels')
plt.xlim(-60,120)
plt.xlabel("Mean")
plt.ylabel("Count")
plt.title("Histogram of Means of Reference Pixels")
plt.savefig("../../images/"+str(month)+"means-ref.png")

##Plot of correlation

##sds_cut = sds[1460:1500,1460:1500].flatten()
##means_cut = means[1460:1500,1460:1500].flatten()
sds_cut = sds.flatten()
means_cut = means.flatten()

plt.figure()
plt.plot(means_cut, sds_cut,'x')
plt.xlim(5,25)
plt.ylim(0,400)
plt.xlabel("Mean")
plt.ylabel("Standard Deviation")
plt.title("Correlation Plot Between Mean and Standard Deviation")
plt.savefig("../../images/"+str(month)+"correlation-high.png")


os.chdir("/Data/routledge/KMOS")

plt.show()
