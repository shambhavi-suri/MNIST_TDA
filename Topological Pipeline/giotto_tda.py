# -*- coding: utf-8 -*-
"""
@author: shambhavi
"""
#%%
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import gtda.images 
import gtda.homology
import gtda.diagrams

#%%
train_1 = pd.read_csv("train.csv")
digit = train_1.y
train = train_1.drop(['Unnamed: 0','y'], axis = 1)
#%%
images = np.zeros((60000,28,28))
for i in range(0,60000):
    images[i] = np.reshape(train.iloc[[i]].to_numpy() ,(28,28))
#%%
#plots 28*28 np array
def plot_image(nparr):
    Q = np.reshape(nparr ,(28,28))
    plt.matshow(Q);
    plt.colorbar()
#%%
#Binarising Data
transformer = gtda.images.Binarizer(threshold = 0.4).fit(images)
binarized_images_1 = transformer.transform(images)  #Gives Boolean array
binarized_images = 1*binarized_images_1             #Converts into int

#%%
#height filtrationed_images
#1 = (1,0)
height_1 = gtda.images.HeightFiltration(direction = np.array([1,0])).fit(binarized_images)
height_1_images = height_1.transform(binarized_images)
#2 = (0,1)
height_2 = gtda.images.HeightFiltration(direction = np.array([0,1])).fit(binarized_images)
height_2_images = height_2.transform(binarized_images)
#3 = (1,1)
height_3 = gtda.images.HeightFiltration(direction = np.array([1,1])).fit(binarized_images)
height_3_images = height_3.transform(binarized_images)
#4 = (-1,1)
height_4 = gtda.images.HeightFiltration(direction = np.array([-1,1])).fit(binarized_images)
height_4_images = height_4.transform(binarized_images)
#5 = (1,-1)
height_5 = gtda.images.HeightFiltration(direction = np.array([1,-1])).fit(binarized_images)
height_5_images = height_5.transform(binarized_images)
#6 = (-1,-1)
height_6 = gtda.images.HeightFiltration(direction = np.array([-1,-1])).fit(binarized_images)
height_6_images = height_6.transform(binarized_images)
#7 = (-1,0)
height_7 = gtda.images.HeightFiltration(direction = np.array([-1,0])).fit(binarized_images)
height_7_images = height_7.transform(binarized_images)
#8 = (0,-1)
height_8 = gtda.images.HeightFiltration(direction = np.array([0,-1])).fit(images)
height_8_images = height_8.transform(binarized_images)
#%%
#radial filtration with 9 different centers 
#1 6,6
radial_filtration_1 = gtda.images.RadialFiltration(center = np.array([6,6])).fit(binarized_images)
radial_1_images = radial_filtration_1.transform(binarized_images)
#2 13,6
radial_filtration_2 = gtda.images.RadialFiltration(center = np.array([13,6])).fit(binarized_images)
radial_2_images = radial_filtration_2.transform(binarized_images)
#3 20,6
radial_filtration_3 = gtda.images.RadialFiltration(center = np.array([20,6])).fit(binarized_images)
radial_3_images = radial_filtration_3.transform(binarized_images)
#4 20,13
radial_filtration_4 = gtda.images.RadialFiltration(center = np.array([20,13])).fit(binarized_images)
radial_4_images = radial_filtration_4.transform(binarized_images)
#5 13,13
radial_filtration_5 = gtda.images.RadialFiltration(center = np.array([13,13])).fit(binarized_images)
radial_5_images = radial_filtration_5.transform(binarized_images)
#6 6,13
radial_filtration_6 = gtda.images.RadialFiltration(center = np.array([6,13])).fit(binarized_images)
radial_6_images = radial_filtration_6.transform(binarized_images)
#7 6,20
radial_filtration_7 = gtda.images.RadialFiltration(center = np.array([6,20])).fit(binarized_images)
radial_7_images = radial_filtration_7.transform(binarized_images)
#8 13.20
radial_filtration_8 = gtda.images.RadialFiltration(center = np.array([13,20])).fit(binarized_images)
radial_8_images = radial_filtration_8.transform(binarized_images)
#9 20,20
radial_filtration_9 = gtda.images.RadialFiltration(center = np.array([20,20])).fit(binarized_images)
radial_9_images = radial_filtration_9.transform(binarized_images)

#%%
#Cubical Complexes for height
cubical_pr = gtda.homology.CubicalPersistence().fit(height_1_images)
cubical_diagrams_1 = cubical_pr.transform(height_1_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(height_2_images)
cubical_diagrams_2 = cubical_pr.transform(height_2_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(height_3_images)
cubical_diagrams_3 = cubical_pr.transform(height_3_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(height_4_images)
cubical_diagrams_4 = cubical_pr.transform(height_4_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(height_5_images)
cubical_diagrams_5 = cubical_pr.transform(height_5_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(height_6_images)
cubical_diagrams_6 = cubical_pr.transform(height_6_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(height_7_images)
cubical_diagrams_7 = cubical_pr.transform(height_7_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(height_8_images)
cubical_diagrams_8 = cubical_pr.transform(height_8_images)

#%%
#compute persistent entropy height filtrations
persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_1)
persistent_entropy_1 = persistent_entropy.transform(cubical_diagrams_1)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_2)
persistent_entropy_2 = persistent_entropy.transform(cubical_diagrams_2)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_3)
persistent_entropy_3 = persistent_entropy.transform(cubical_diagrams_3)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_4)
persistent_entropy_4 = persistent_entropy.transform(cubical_diagrams_4)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_5)
persistent_entropy_5 = persistent_entropy.transform(cubical_diagrams_5)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_6)
persistent_entropy_6 = persistent_entropy.transform(cubical_diagrams_6)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_7)
persistent_entropy_7 = persistent_entropy.transform(cubical_diagrams_7)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_8)
persistent_entropy_8 = persistent_entropy.transform(cubical_diagrams_8)


height_data = np.concatenate((persistent_entropy_1,persistent_entropy_2,
                              persistent_entropy_3,persistent_entropy_4,
                              persistent_entropy_5,persistent_entropy_6,
                              persistent_entropy_7,persistent_entropy_8), axis = 1)

height_data_pd = pd.DataFrame(height_data)
height_data_pd.to_csv('height_data.csv')

#%%
#cubical complex radial
cubical_pr = gtda.homology.CubicalPersistence().fit(radial_1_images)
cubical_diagrams_1_1 = cubical_pr.transform(radial_1_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(radial_2_images)
cubical_diagrams_2_1 = cubical_pr.transform(radial_2_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(radial_3_images)
cubical_diagrams_3_1 = cubical_pr.transform(radial_3_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(radial_4_images)
cubical_diagrams_4_1 = cubical_pr.transform(radial_4_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(radial_5_images)
cubical_diagrams_5_1 = cubical_pr.transform(radial_5_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(radial_6_images)
cubical_diagrams_6_1 = cubical_pr.transform(radial_6_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(radial_7_images)
cubical_diagrams_7_1 = cubical_pr.transform(radial_7_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(radial_8_images)
cubical_diagrams_8_1 = cubical_pr.transform(radial_8_images)

cubical_pr = gtda.homology.CubicalPersistence().fit(radial_9_images)
cubical_diagrams_9_1 = cubical_pr.transform(radial_9_images)

#%%
#compute persistent entropy radial filtrations
persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_1_1)
persistent_entropy_1_1 = persistent_entropy.transform(cubical_diagrams_1_1)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_2_1)
persistent_entropy_2_1 = persistent_entropy.transform(cubical_diagrams_2_1)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_3_1)
persistent_entropy_3_1 = persistent_entropy.transform(cubical_diagrams_3_1)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_4_1)
persistent_entropy_4_1 = persistent_entropy.transform(cubical_diagrams_4_1)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_5_1)
persistent_entropy_5_1 = persistent_entropy.transform(cubical_diagrams_5_1)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_6_1)
persistent_entropy_6_1 = persistent_entropy.transform(cubical_diagrams_6_1)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_7_1)
persistent_entropy_7_1 = persistent_entropy.transform(cubical_diagrams_7_1)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_8_1)
persistent_entropy_8_1 = persistent_entropy.transform(cubical_diagrams_8_1)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_9_1)
persistent_entropy_9_1 = persistent_entropy.transform(cubical_diagrams_9_1)

#%%
radial_data = np.concatenate((persistent_entropy_1_1,persistent_entropy_2_1,
                              persistent_entropy_3_1,persistent_entropy_4_1,
                              persistent_entropy_5_1,persistent_entropy_6_1,
                              persistent_entropy_7_1,persistent_entropy_8_1,
                              persistent_entropy_9_1), axis = 1)

radial_data_pd = pd.DataFrame(radial_data)
radial_data_pd.to_csv('radial_data.csv')

#%%
#Grayscale_data cubical_homology

cubical_pr = gtda.homology.CubicalPersistence().fit(images)
cubical_diagrams_g = cubical_pr.transform(images)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_g)
persistent_entropy_10 = persistent_entropy.transform(cubical_diagrams_g)

gray_data_pd = pd.DataFrame(persistent_entropy_10)

data = np.concatenate((height_data, radial_data, persistent_entropy_10), axis =  1)
pd.DataFrame(data).to_csv('data.csv')

#%% 
#Defining density filtration wrt L1 norm
def nbhd(nparr, arr, r):
    i = arr[0]
    j = arr[1]
    counter = 0
    for x in range(max(i-r,0),min(27,i+r)):
        for y in range (max(j-r,0),min(28,j+r+1)):
            if (abs(x-i)+abs(y-j) <= r) and nparr[x][y] == 1:
                counter = counter + 1
    return counter

def density_filtration(nparr,r):
    mat = np.zeros((28,28))
    for m in range(0,27):
        for n in range(0,27):
            mat[m][n] = nbhd(nparr, np.array((m,n)), r)
    return mat

#%%
#density filtration for radii 2,4,6
density_filtration_images = np.zeros((3,60000,28,28))
for k in range(16000, 60000):
    density_filtration_images[0][k] = density_filtration(binarized_images[k],2)
    density_filtration_images[1][k] = density_filtration(binarized_images[k],4)
    density_filtration_images[2][k] = density_filtration(binarized_images[k],6)
    if k % 1000 == 0:
        print(k)

#%%
#cubical homology
cubical_pr = gtda.homology.CubicalPersistence().fit(density_filtration_images[0])
cubical_diagrams_11 = cubical_pr.transform(density_filtration_images[0])

cubical_pr = gtda.homology.CubicalPersistence().fit(density_filtration_images[1])
cubical_diagrams_12 = cubical_pr.transform(density_filtration_images[1])

cubical_pr = gtda.homology.CubicalPersistence().fit(density_filtration_images[2])
cubical_diagrams_13 = cubical_pr.transform(density_filtration_images[2])

#%%

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_11)
persistent_entropy_11 = persistent_entropy.transform(cubical_diagrams_11)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_12)
persistent_entropy_12 = persistent_entropy.transform(cubical_diagrams_12)

persistent_entropy = gtda.diagrams.PersistenceEntropy().fit(cubical_diagrams_13)
persistent_entropy_13 = persistent_entropy.transform(cubical_diagrams_13)

density_filtration_data = pd.DataFrame(np.concatenate((persistent_entropy_11,
                                                       persistent_entropy_12,
                                                       persistent_entropy_13),
                                                      axis = 1))
density_filtration_data.to_csv('density_data.csv')
#%%
total_data = np.concatenate((data,persistent_entropy_11,persistent_entropy_12,
                             persistent_entropy_13), axis = 1)

pd.DataFrame(total_data).to_csv('total_data.csv')


total_data_1 = pd.read_csv('total_data.csv')
total_data = total_data_1.drop(['Unnamed: 0'], axis = 1)




