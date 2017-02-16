"""
Code to analyse KMOS data in order to determine
the underlying distribution of the pixel values.

Created By: Laurence Routledge
Created On: 15/11/2016
Last Modified: 16/02/2017
"""

import os
from glob import glob

import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits
from scipy.interpolate import spline

month='sept'
os.chdir("/Data/routledge/KMOS/data/"+str(month))    #directory containing the data

#load in the mean and variance data (see 'kmos.py')
all_means=np.zeros((3,2048,2048))
all_means[0,:,:]=np.load('means_det_1.npy')
all_means[1,:,:]=np.load('means_det_2.npy')
all_means[2,:,:]=np.load('means_det_3.npy')

all_vars=np.zeros((3,2048,2048))
all_vars[0,:,:]=np.load('var_det_1.npy')
all_vars[1,:,:]=np.load('var_det_2.npy')
all_vars[2,:,:]=np.load('var_det_3.npy')

all_sds=np.sqrt(all_vars)               #convert to sd

def means(det='all'):
    '''
    Function to extract the pixel means from the non-reference pixels
    Inputs:
    det: which detector to use (default is all)
    '''
    det=str(det)
    means_cent = all_means[:,4:2044,4:2044]

    if det=='all':
        means_cent = means_cent.flatten()
    elif det=='1':
        means_cent = means_cent[0].flatten()
    elif det=='2':
        means_cent = means_cent[1].flatten()
    elif det=='3':
        means_cent = means_cent[2].flatten()
    return means_cent
        
def means_ref(det='all'):
    '''
    Function to extract just the reference pixel means
    Inputs:
    det: which detector to use (default is all)
    '''
    det=str(det)
    means_ref_1 = np.concatenate((all_means[0,2044:2047,:].flatten(), all_means[0,4:2044,0:4].flatten()))
    means_ref_2 = np.concatenate((all_means[1,2044:2047,:].flatten(), all_means[1,4:2044,0:4].flatten(),\
                                  all_means[1,4:2044,2044:2047].flatten()))
    means_ref_3 = np.concatenate((all_means[2,2044:2047,:].flatten(), all_means[2,4:2044,0:4].flatten(),\
                                  all_means[2,4:2044,2044:2047].flatten()))
    means_ref_3_sides = np.concatenate((all_means[2,4:2044,2044:2047].flatten(), all_means[2,4:2044,0:4].flatten()))
    means_ref_3_top = all_means[2,2044:2047,:].flatten()
    if det=='all':
        means_ref_data = np.concatenate((means_ref_1, means_ref_2, means_ref_3))
    elif det=='1':
        means_ref_data = means_ref_1
    elif det=='2':
        means_ref_data = means_ref_2
    elif det=='3':
        means_ref_data = means_ref_3
    return means_ref_data
        
def sds(det='all'):
    '''
    Function to extract the pixel sandard deviations from the non-reference pixels
    Inputs:
    det: which detector to use (default is all)
    '''
    det=str(det)
    sds_cent = all_sds[:,4:2044,4:2044]

    if det=='all':
         sds_cent = sds_cent.flatten()
    elif det=='1':
        sds_cent = sds_cent[0].flatten()
    elif det=='2':
        sds_cent = sds_cent[1].flatten()
    elif det=='3':
        sds_cent = sds_cent[2].flatten()
    return sds_cent
        
def sds_ref(det='all'):
    '''
    Function to extract just the reference pixel standard deviations
    Inputs:
    det: which detector to use (default is all)
    '''
    det=str(det)
    sds_ref_1 = np.concatenate((all_sds[0,2044:2047,:].flatten(), all_sds[0,4:2044,0:4].flatten()))
    sds_ref_2 = np.concatenate((all_sds[1,2044:2047,:].flatten(), all_sds[1,4:2044,0:4].flatten(),\
                                all_sds[1,4:2044,2044:2047].flatten()))
    sds_ref_3 = np.concatenate((all_sds[2,2044:2047,:].flatten(), all_sds[2,4:2044,0:4].flatten(),\
                                all_sds[2,4:2044,2044:2047].flatten()))
    sds_ref_3_sides = np.concatenate((all_sds[0,4:2044,2044:2047].flatten(), all_sds[0,4:2044,0:4].flatten()))
    sds_ref_3_top_bottom = np.concatenate((all_sds[0,2044:2047,:].flatten(), all_sds[0,0:4,:].flatten()))

    if det=='all':
        sds_ref_data = np.concatenate((sds_ref_1, sds_ref_2, sds_ref_3))
    elif det=='1':
        sds_ref_data = sds_ref_1
    elif det=='2':
        sds_ref_data = sds_ref_2
    elif det=='3':
        sds_ref_data = sds_ref_3
    return sds_ref_data

#Make plots

#plots of means
bins_all = np.arange(-600,10000,0.25)
hist_all, bin_edges_all = np.histogram(means(3), bins_all)
plt.figure()
plt.semilogy(bin_edges_all[:-1]+0.125, hist_all, label='all data')
plt.xlim(-5,10)
plt.xlabel("Mean")
plt.ylabel("Count")
plt.title("Histogram of Means of Pixels")
#plt.savefig("../../images/"+str(month)+"/means-all.png")

bins_ref = np.arange(-400,610,0.25)
hist_ref, bin_edges_ref = np.histogram(means_ref(3), bins_ref)
plt.figure()
plt.semilogy(bin_edges_ref[:-1]+0.125, hist_ref, label='ref pixels')
plt.xlim(-5,10)
plt.xlabel("Mean")
plt.ylabel("Count")
plt.title("Histogram of Means of Reference Pixels")
#plt.savefig("../../images/"+str(month)+"/means-ref.png")

     
#plots of standard deviations
bins = np.arange(0,63000,0.25)
hist, bin_edges = np.histogram(sds(3), bins)
plt.figure()
plt.semilogy(bin_edges[:-1]+0.125, hist, label='all_data')
plt.xlim(0,10)
plt.xlabel("Standard Deviation")
plt.ylabel("Log Count")
plt.title("Histogram of Standard Deviations of Pixels")
#plt.savefig("../../images/"+str(month)+"/st-devs-all.png")

bins_ref = np.arange(0,66,0.25)
hist_ref,bin_edges_ref = np.histogram(sds_ref(3), bins_ref)
plt.figure()
plt.semilogy(bin_edges_ref[:-1]+0.125, hist_ref, label='ref_data')
plt.xlim(0,10)
plt.xlabel("Standard Deviation")
plt.ylabel("Log Count")
plt.title("Histogram of Standard Deviations of Reference Pixels")
#plt.savefig("../../images/"+str(month)+"/st-devs-ref.png")

'''
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

'''
os.chdir("/Data/routledge/KMOS/code")

plt.show()


