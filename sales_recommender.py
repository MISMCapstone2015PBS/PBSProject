# Sai J

# Association rule Mining and Recommendation System based on Sales data

import os 
import time
import datetime
import time
import math
from operator import mul

from __future__ import division
from itertools import combinations

import numpy as np
import scipy as sc
import pandas as pd

# Get Sales data and clean it. Pickle it
def clean_pickle(path):
    list_of_files = os.listdir(path)
    text_files = [x for x in list_of_files if x[-3:]=='txt']
    xls_files = [x for x in list_of_files if x[-4:]=='xlsx']
    for i in range(len(xls_files)):
        if i==0:
            sales_df = pd.read_excel(path+ xls_files[i])
        else:
            sales_df = pd.concat([sales_df, pd.read_excel(path+xls_files[i])], axis =0)

    for f in text_files:     
        sales_df.append(pd.read_csv(path+f,sep='\t'), ignore_index = True)

    sales_df = sales_df.reset_index()
    sales_df['Download Date (PST)'] = pd.to_datetime(sales_df["Download Date (PST)"])
    sales_df = sales_df.reset_index().drop('index',axis=1)

    sales_df.to_pickle("sales_df.p")
    sales_df.to_csv('sales_df.csv' , encoding = 'utf-8')
    
    
# Convert sales data into vector for associations rule mining
def get_assoc_df(df):
    # Filter: Currency= USD; Ignore returns. Keep only Sales.
    df['Currency'] = [str(x) for x in df['Customer Currency']]
    df = df[df['Currency']=='USD']
    df = df[df['Sale/Return']=='S']

    # Drop Columns: 
    # Provider, ISRC(Sparse), Order Id, PreOrder(Sparse),CMA(Redundant-Sale/Return), 
    # Vendor Offer Code, Promo Code, Parent Type Id, Provider Country (Redundant), UPC (Sparse),
    # Report Date,Royalty Currency, ISAN(Sparse), Apple Identifier, Grid (Sparse), Attributable Purchase (Sparse)
    df = df.drop(['level_0','Provider','ISRC','Order Id', 'PreOrder', 'CMA', 'Vendor Offer Code', 'Promo Code','Parent Identifier','Parent Type Id','Provider Country', 'UPC', 'Report Date (Local)','Sale/Return','Customer Currency','Royalty Currency', 'ISAN','Apple Identifier', 'Grid', 'Attributable Purchase'], axis=1)

    # Association Rule Mining using Apriori
    df_pivot = pd.pivot_table(df[['Artist / Show', 'Customer Identifier', 'Units']],index = 'Customer Identifier', columns = 'Artist / Show', fill_value = 0).reset_index()
    df_pivot.to_pickle('df_pivot.p')
    df_assoc = df_pivot['Units']
    del df_assoc[' ']
    return df_assoc  

# Develop code for Apriori Algo
# Input = Pandas DataFrame with Columns as items whose associaton rules need to be identified
# & rows as individual transactions. Values are binary: 0s and 1s.
# 0: Non-occurrence
# 1: Occurrence
# No NaNs or Nulls

# Takes a list of iterable values (columns or combination of columns) and returns next set of combinations
def filter_support(iterable, data, support= None, lift_base= None):
    if (((support is None) & (lift_base is None)) | ((support is not None) & (lift_base is not None))):
        print 'Supply proper Support or Lift_base'
        return None
    passed_threshold = []
    len_data = len(data)
    if type(iterable[0])==list:
        combined_list = list(set([y for x in iterable for y in x]))
        len_list = len(iterable[0])
    else:
        combined_list = iterable
        len_list = 1
    list_comb = combinations(combined_list, len_list+1)
    for item in list_comb:
        cols = list(item) # Convert into list since combinations returns tuples
        assoc_prob = sum(data[cols].product(axis=1))/len_data # Get proportion of the combination where all columns are 1s
        if (support is not None) & (assoc_prob>= support): # If absolute support is known
            passed_threshold.append(cols)
            continue
        orig_prob = reduce(mul,[sum(data[col])/len_data for col in cols],1) # Probabilistic Likelihood of association
        if (lift_base is not None) & (orig_prob!=0) & ((assoc_prob/orig_prob)>=lift_base):
            passed_threshold.append(cols)
            continue
    return passed_threshold

def get_assoc_list(max_assoc_len, init_col_list, data, support= None, lift_base = None):
    len_list = 1
    next_iter = init_col_list
    final_assoc_list = []

    while (len_list < max_assoc_len) & (len(next_iter)>1):
        next_iter = filter_support(next_iter, data, None, lift_base)
        final_assoc_list = final_assoc_list + next_iter
        if len(next_iter)!=0:
            len_list = len(next_iter[0])
        else:
            break
    return final_assoc_list

# Use association rules to generate user-specific recommendations
def get_reco(data, assoc_rules):
    user_reco = {}
    for i in range(len(assoc_df)):
        user_pref = assoc_df.loc[i]
        for assoc_rule in final_assoc_list:
            common = [k for k,v in (dict(user_pref)).items() if v==1 and k in assoc_rule]
            reco = [x for x in assoc_rule if x not in user_pref]
            if (len(common)>0) & (len(reco)>0):
                print 'Common = ', common, len(common)
                print reco
                user_reco[i] = [reco,len(common)/len(assoc_rule)]
    return user_reco
