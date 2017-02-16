"""Created By: Laurence Routledge
Created On: 06/12/2016
Last Modified: 08/12/2016"""

import os

import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import UnivariateSpline
from astropy.io import fits
from astropy.convolution import convolve

os.chdir("/Data/routledge/KMOS/data/oct")

means = np.load("means.npy")
var = np.load("var.npy")
sds = np.sqrt(var)
col_meds = np.load("col_meds.npy")

col_meds = col_meds.flatten()

##def func(x):
##    return (x**2)*np.exp(-x)
##
##x_vals=np.arange(-40,60,0.1)
##
##plt.plot(x_vals, func(x_vals))

bins = np.arange(-600,400000,0.1)
hist, bin_edges = np.histogram(means, bins)

X = bin_edges[:-1]+0.05

zero_locs = np.where(hist==0)

hist = np.array(hist, dtype = 'float')
hist = np.delete(hist, zero_locs)
X = np.delete(X, zero_locs)
cumulative = np.cumsum(hist)
cum_prob = cumulative/np.float(np.max(cumulative))

X_means = np.sort(means.flatten())
cum_prob_means = np.array(range(len(means.flatten())))/float(len(means.flatten()))

func_means = UnivariateSpline(cum_prob_means, X_means, k=4, s=0)

X_sds = np.sort(sds.flatten())
cum_prob_sds = np.array(range(len(sds.flatten())))/float(len(sds.flatten()))

func_sds = UnivariateSpline(cum_prob_sds, X_sds, k=4, s=0)

side_len = 512

print 'generating means'
sim_means = func_means(np.random.random(side_len**2))

print 'generating sds'
sim_sds = func_sds(np.random.random(side_len**2))

##for i in range(side_len**2):
##    print i
##    rand1 = np.random.random()
##    sim_means = func_means(rand1)
##    rand2 = np.random.random()
##    sim_sds = func_sds(rand2)
    

def gaussian(x, mu, sig):
    return np.exp(-np.power(x - mu, 2.) / (2 * np.power(sig, 2.)))

sim_array = np.zeros((side_len**2))

for i in range(side_len**2):
    print i, '/', side_len**2
    mu, sig = sim_means[i], sim_sds[i]
    lower_lim = np.round(mu-(10*sig),2)
    upper_lim = np.round(mu+(10*sig),2)
    x_range = np.arange(lower_lim, upper_lim, 0.01)
    gauss_func  = gaussian(x_range, mu, sig)
    prob = gauss_func/np.sum(gauss_func)
    sim_array[i]+= np.random.choice(x_range,p=prob)
    
sim_array = sim_array.reshape((side_len,side_len))


for i in range(side_len):
    row_av = np.median(np.concatenate((sim_array[i,:4], sim_array[i,-4:])))
    sim_array[i] -= row_av

for i in range(side_len/64):
    sim_array[:,64*i:64*(i+1)] -= np.random.choice(col_meds)
##    col_av = np.median(np.concatenate((sim_array[:4,64*i:64*(i+1)], sim_array[-4:,64*i:64*(i+1)])))
##    print col_av
##    sim_array[:,64*i:64*(i+1)] -= col_av

kernel = np.array([[0,2,0],[2,100,2],[0,2,0]])

high_vals = np.where(sim_array > 80)

for i in range(len(high_vals[0])):
    if np.random.random() > 0.9:
        if high_vals[0][i] != 511 and high_vals[1][i] != 511:
            sim_array[high_vals[0][i]:high_vals[0][i]+3, high_vals[1][i]:high_vals[1][i]+3] = sim_array[high_vals[0][i],high_vals[1][i]]
        else:
            sim_array[high_vals[0][i]:high_vals[0][i]-3, high_vals[1][i]:high_vals[1][i]-3] = sim_array[high_vals[0][i],high_vals[1][i]]
    else: None           

##sim_array = convolve(sim_array, kernel, normalize_kernel=True)

data = fits.getdata('KMOS.2016-10-01T23:49:52.352.fits')
data = data[:512,:512]

plt.figure()
plt.imshow(sim_array, cmap='gray', vmin=-40, vmax=40)
plt.colorbar()
plt.title('Simulated (medians)')
plt.savefig('simulated-medians.png')

plt.figure()
plt.imshow(data, cmap='gray', vmin=-40, vmax=40)
plt.colorbar()
plt.title('Real')
plt.savefig('real.png')

plt.show()

'''
plt.figure()
#plt.plot(bin_edges[:-1]+0.05, hist)
#plt.semilogy(bin_edges[:-1]+0.05, cumulative_scaled)
plt.plot(X, cum_prob, color='g')
plt.plot(X, func(X), color='b')
#plt.xlim(-600,1200)
#plt.ylim(0,1)
plt.xlabel("Mean")
plt.ylabel("Count")
plt.title("Histogram of Means of Pixels")

plt.show()
''' 
os.chdir("../..")
