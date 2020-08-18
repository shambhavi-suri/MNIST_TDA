# -*- coding: utf-8 -*-
"""
Created on Thu Aug 13 15:45:50 2020

@author: shambhavi
"""

#%%
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import gtda.homology
import gtda.diagrams

#%% 
# ax+by+c denotes line we are considering
def direction_filtration(Q,a,b,c, par = True):
    shape_x = np.shape(Q)[0]
    shape_y = np.shape(Q)[1]
    Qnew = np.zeros((shape_x,shape_y))
    for i in range(0,shape_x):
        for j in range(0,shape_y):
            if par and Q[i][j] == 1:
                Qnew[i][j] = abs(a*i + b*j + c)/((a**2 + b**2)**(1/2))
            if par != True and Q[i][j] == 1:
                Qnew[i][j] = -1 * abs(a*i + b*j + c)/((a**2 + b**2)**(1/2))
    max_val = np.max(Qnew)
    for i in range(0,shape_x):
        for j in range(0,shape_y):
            if Q[i][j] == 0:
                Qnew[i][j] = max_val+5
    return Qnew
#%%
def plot_image(Q):
    plt.matshow(Q);
    plt.colorbar()
    
#%%
#line filtration
l = np.array((True, True, False, False))
coeff = [[1,-1,-20],[0,1,-27],[0,1,-13],[1,0,-13]]
line_data = np.zeros((np.shape(coeff)[0],60000,28,28))  
for k in range(0,60000):
    for t in range(0,np.shape(coeff)[0]):
        line_data[t][k] = direction_filtration(binarized_images[k], a = coeff[t][0]
                                               ,b = coeff[t][1]
                                               ,c = coeff[t][2]
                                               ,par = l[t])
    if k % 1000 == 0:
        print(k)
#%%
#Cubical Homology Data       
cubical_pr = gtda.homology.CubicalPersistence().fit(line_data[0])
cubical_diagrams_line_1 = cubical_pr.transform(line_data[0])
cubical_pr = gtda.homology.CubicalPersistence().fit(line_data[1])
cubical_diagrams_line_2 = cubical_pr.transform(line_data[1])
cubical_pr = gtda.homology.CubicalPersistence().fit(line_data[2])
cubical_diagrams_line_3 = cubical_pr.transform(line_data[2])
cubical_pr = gtda.homology.CubicalPersistence().fit(line_data[3])
cubical_diagrams_line_4 = cubical_pr.transform(line_data[3])

#%%
#Perisistent Entropy
line_per_ent_data = np.zeros((60000,2*np.shape(coeff)[0]))    
persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_line_1 )
line_per_ent_data[:,0:2] = persistent_entropy.transform(cubical_diagrams_line_1)
persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_line_1 )
line_per_ent_data[:,2:4] = persistent_entropy.transform(cubical_diagrams_line_1)
persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_line_1 )
line_per_ent_data[:,4:6] = persistent_entropy.transform(cubical_diagrams_line_1)
persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_line_1 )
line_per_ent_data[:,6:8] = persistent_entropy.transform(cubical_diagrams_line_1)

#%%
#loading land data
pd.DataFrame(line_per_ent_data).to_csv('line_data.csv')
line_data = np.array(pd.read_csv('line_data.csv'))[:,1:9]

