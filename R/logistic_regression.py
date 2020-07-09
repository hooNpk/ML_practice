"""
Nominal Logistic Regression
결과값이 유한할 때(명목적일 때)
Target Value = A, B, C, ..., K

Binary Logistic Regression은 Nominal Logistic Regression의
특수한 경우로 Target Value = 0 or 1


CSV file should be with this python file
"""

import math
import numpy as np
import pandas as pd

file_name = "(4)logistic_regression_admission.csv"

df = pd.read_csv(file_name)
target = 'admit'
variable = list(df.columns)
variable.remove(target)

def exp(arg, value):
    #return exp⁡(α_A0+ α_A1*X_1+ α_A2*X_2) , D_A
    val = arg[0]
    for i in range(0, len(arg)-1):
        val += arg[i+1]*value[i]
    return math.exp(val)

def clause(arg, value, category):
    #return log(D_A / 1+D_A+D_B+D_C)
    denominator = 1
    valueL = [value[val] for val in variable]
    consequence = value[target]

    for i in range(len(category)-1):
        denominator += exp(arg[category[i]], valueL)
    numerator = exp(arg[consequence], valueL)
    return math.log(numerator/denominator)

def log_likelihood_func(var_num):
    #variable 갯수와 category 갯수를 매개변수로 받는다
    #Target Value가 0, 1 뿐이라면 category_num = 2
    #Target Value가 A, B, C 라면 category_num = 3
    
    category = []
    for val in df[target]:
        if val not in category:
            category.append(val)
    category.sort()

    category_num = len(category)#category는 {A,B, A, C}인 경우 [A, B, C]
    arg = {category[i]:[0 for j in range(var_num)] for i in range(category_num)}

    func = 0
    for i in range(400):
        func += clause(arg, df.loc[i, :], category)
    

#log_likelihood_func(len(variable))
print(df.loc[0, : ])
ser = df.loc[2, :]
print(ser)
print(ser['gre'])
print(type(df.loc[1, :]))
print(df.shape)

