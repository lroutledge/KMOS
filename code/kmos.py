"""
Code to read in KMOS darks and determine the
mean and standard deviation of each pixel in
the image across several frames.

Created By: Laurence Routledge
Created On: 14/11/2016
Last Modified: 16/02/2017
"""

import os
from glob import glob
import gc

import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits

os.chdir("/Data/routledge/KMOS/data/oct")    #directory containing the data

fits_files = glob("*.fits")         #gets all the fits files
max_range = len(fits_files)

print "Number of fits files: ", max_range

shape = (2048, 2048)                #shape of the images

def get_means_sds(det):
    det+=1
    #set up blank arrays to update when looping through each image
    means = np.zeros(shape)
    var = np.zeros(shape)
    M2 = np.zeros(shape)

    col_meds=[]
    row_meds=[]

    #begin the loop through all files
    for i in range(max_range):
        print "File number", i + 1

        #read in the data
        hdulist=fits.open(fits_files[i])
        data = hdulist[det].data

        #first remove the median of 64 colums
        for j in range(len(data)/64):
            col_meds.append(np.median(data[:, 64 * j:64 * (j + 1)]))
            data[:, 64 * j:64 * (j + 1)] -= np.median(data[:, 64 * j:64 * (j + 1)])

        #then remove the median of each row
        for k in range(len(data)):
            row_meds.append(np.median(data[k]))
            data[k] -= np.median(data[k])

        #this is an implementation of Welford's algorithm   
        delta = data - means            #difference from previous mean
        means += delta / (i + 1.)       #update mean
        new_delta = data - means        #difference from new mean

        M2 += delta * new_delta         #update sum of differences 

        #account for potential divide by zero
        if i == 0:
            None
        else:
            var = M2 / i          #update variance

        print "Finished\n"
    
        gc.collect()
   
    #save the data to be read in by other scripts
    np.save("means_det_"+str(det), means)
    np.save("var_det_"+str(det), var)

#loop over all 3 detectors
for i in range(3):
    print "Detector",i+1,"\n"
    get_means_sds(i)

##bins = np.arange(-20, 420, 0.1)
##hist, bin_edges=np.histogram(row_meds, bins)
##    
##plt.figure()
##plt.semilogy(bin_edges[:-1] + 0.05, hist)
##plt.title('Histogram of Subtracted Medians')
##plt.xlabel('Median substracted')
##plt.ylabel('Count')
##plt.xlim(-10,10)
##
##plt.savefig("medians.png")
##
##row_meds = np.array(row_meds).reshape((2048,max_range))
##col_meds = np.array(col_meds).reshape((32,max_range))
##
##np.save("row_meds", row_meds)
##np.save("col_meds", col_meds)
    
##plt.show()

os.chdir("/Data/routledge/KMOS/code")

