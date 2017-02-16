import numpy as np
import matplotlib.pyplot as plt

fake_array=np.zeros((512,512))

def gaussian(x, mu, sig):
    return np.exp(-np.power(x - mu, 2.) / (2 * np.power(sig, 2.)))


def L(x, mu, gamma):
    """ Return Lorentzian line shape at x with HWHM gamma """
    return gamma / np.pi / ((x - mu)**2 + gamma**2)

x_range = np.arange(0, 100, 0.01)
gauss_func = gaussian(x_range, 50, 2.5)/np.sum(gaussian(x_range, 50, 2.5))
lorentz_func = L(x_range, 50, 5)/np.sum(L(x_range, 50, 5))

func=lorentz_func

#plt.plot(x_range, gauss_func)
#plt.show()


for k in range(10):
    print k
    for i in range(len(fake_array)):
        for j in range(len(fake_array)):
           fake_array[i,j] += np.random.choice(x_range,p=func)

##plt.figure()
##plt.imshow(fake_array, cmap='gray')
##plt.colorbar()
##
##bins=np.arange(25, 75, 0.1)
##        
##hist, bin_edges=np.histogram(fake_array,bins)
##
##plt.figure()
##plt.plot(bin_edges[:-1] + 0.05, hist)
###plt.plot(x_range, func/max(func), 'r-')

    for i in range(len(fake_array)):
        row_av = np.mean(np.concatenate((fake_array[i,:4], fake_array[i,-4:])))
        fake_array[i] -= row_av

    for i in range(len(fake_array)/64):
        col_av = np.mean(np.concatenate((fake_array[:4,64*i:64*(i+1)], fake_array[-4:,64*i:64*(i+1)])))
        fake_array[:,64*i:64*(i+1)] -= col_av

'''
plt.figure()
plt.imshow(fake_array, cmap='gray')
plt.title('after')
plt.colorbar()

bins=np.arange(-20, 20, 0.1)
        
hist, bin_edges=np.histogram(fake_array,bins)

plt.figure()
plt.plot(bin_edges[:-1] + 0.05, hist)
#plt.plot(x_range, gauss_func/max(gauss_func), 'r-')

plt.show()'''
