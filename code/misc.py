"""
Misc code currently not being used

Created On: 16/02/2017
"""

##kmos_analysis.py

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

## -------------------------------------------------------------------------- ##
