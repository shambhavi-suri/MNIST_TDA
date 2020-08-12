# -*- coding: utf-8 -*-
"""
Created on Tue Aug 11 20:08:09 2020

@author: shambhavi
"""

#%%
import pandas as pd
import numpy as np
from sklearn import preprocessing
from sklearn.ensemble import RandomForestClassifier
from sklearn import metrics
import random

#%%

total_data_1 = pd.read_csv('total_data.csv')
total_data = total_data_1.drop(['Unnamed: 0'], axis = 1)
data = preprocessing.scale(np.array(total_data))

train_1 = pd.read_csv("train.csv")
digit = train_1.y
                     
#%%
train_data = data[:50000]
test_data = data[50000:]
digit_train = digit[:50000]
digit_test = digit[50000:]

#%%
random.seed(31415)
classifier = RandomForestClassifier(max_depth = 1000)
classifier.fit(train_data,digit_train)

test_pred = classifier.predict(test_data)

diff = pd.DataFrame(test_pred - digit_test)
mismatch = diff[diff['y'] != 0]

cm = metrics.confusion_matrix(digit_test, test_pred, labels = [0,1,2,3,4,5,6,7,8,9])
