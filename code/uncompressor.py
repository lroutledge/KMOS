"""
Code to uncompress downloaded fits files from
the ESO archive.

Created by: Laurence Routledge
Created on: 14/11/2016
Last Modified: 29/11/2016

"""
import os

#directory containing files to uncompress
os.chdir("/Data/routledge/KMOS/data/sept")

#all files
files=os.listdir(os.getcwd())

Z_files=[]

#find files ending wih .Z
for i in files:
    if i.endswith('.Z'):
        Z_files.append(i)
    else: None

print len(Z_files)

#pass the uncompress command to the terminal
for i in Z_files:
    print i
    os.system("uncompress "+str(i)) 
