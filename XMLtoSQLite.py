# Sai J

# Parse XML Files and create Pandas dataframes

# Convert Pandas Dataframe to SQLite DB

import os 
import time

import numpy as np
import scipy as sc
import pandas as pd

import sqlite3 as sql

import xml.etree.ElementTree as ET

# Root--> Consists of Blocks --> Has Children --> Have text
def xml_to_df(file_path, xml_file):
    xml_file_name = file_path + '/' + xml_file
    xml_tree = ET.parse(xml_file_name) # Get file and parse. Convert to XML Tree object.
    xml_root = xml_tree.getroot() # Get root of XML tree
    # Create a basic table structure from blocks in XML Tree
    xml_table = pd.DataFrame([x.attrib for x in xml_root if x.tag==[block.tag for block in xml_root][0]])
    del xml_table['Action']
    # Get exhaustive list of all tags/attributes in each child
    tags = list(set([y for x in [[child.tag for child in z] for z in xml_root if z.tag==[block.tag for block in xml_root][0]] for y in x] ))
    # Get text in each child (None if no child) for each block in tree anc convert to list of dictionaries
    children = [{child_tag:[None if x.find(child_tag)==None else x.find(child_tag).text for x in xml_root]} for child_tag in tags]
    children_df = pd.DataFrame()
    for child in children:
        children_df = pd.concat([children_df, pd.DataFrame(child)], axis=1)
    xml_table = pd.concat([xml_table, children_df], axis=1)
    return xml_table

def xml_to_sqlite(path):
    file = open('PBS_DBcreate_log-{0}.txt'.format(time.localtime()),'w')
    file.write('Process started\n')
    list_of_files = os.listdir(path)
    conn = sql.connect('PBS.db')
    cur = conn.cursor()
    for xml_file in list_of_files:
        start_time = time.time()
        table_name = xml_file.split('-')[2:-1]
        if len(table_name) == 0:
            file.write('Skipped {0} file at {1} in {2} seconds due to invalid name\n'.format(xml_file, time.localtime(), end_time - start_time))  
            continue
        else:
            df = xml_to_df(path,xml_file)
            df.to_sql(table_name[0], conn,if_exists = 'append' ,flavor ='sqlite', index = False)
            end_time = time.time()
            file.write('Created/Modified {0} using {1} at {2} in {3} seconds\n'.format(table_name[0], xml_file, time.localtime(), end_time - start_time))  
    file.close()
    conn.close()

