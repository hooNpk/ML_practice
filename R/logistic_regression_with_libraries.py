import numpy as np
import pandas as pd

from scipy.stats import spearmanr

from pylab import rcParams
import seaborn as sb
import matplotlib.pyplot as plt

import sklearn
from sklearn.preprocessing import scale
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn import metrics
from sklearn import preprocessing

data = '(4)logistic_regression_admission.csv'
df = pd.read_csv(data)
target = 'admit'
Y_data = df[target].values
X_data = df.loc[:, ['gre', 'gpa', 'rank']].values
#pandas.DataFrame.values
#return only values which is numpy lost

"""
print(type(X_data))
print(X_data)
print(df.head())
print(df.info())
"""

#sb.regplot(x='gre', y='admit', data=df, scatter=True)
"""
gre = df['gre']
gpa = df['gpa']
spearman_coefficient, p_value = spearmanr(gre, gpa)
print('Spearmanr Rank Correlation Coefficient %0.3f' % (spearman_coefficient))
"""
X_data = scale(X_data)

LogReg = LogisticRegression()
LogReg.fit(X_data, Y_data)
#print(LogReg.score(X_data, Y_data))

param = LogReg.get_params()
print(type(param))
print(param)

y_pred = LogReg.predict(X_data)
from sklearn.metrics import classification_report

#print(classification_report(Y_data, y_pred))