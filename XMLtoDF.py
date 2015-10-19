# Sai J

# Converts XML file to Pandas Dataframe.
# Tested for Assets and Package files. Worked well.
#Need to test for other files.
import numpy as np
import scipy as sc
import pandas as pd

import sqlite3

import xml.etree.ElementTree as ET

# Input name string with .xml suffix
def xml_to_df(xml_file_name):
    xml_tree = ET.parse(xml_file_name)
    xml_root = xml_tree.getroot()
    xml_table = pd.DataFrame([block.attrib for block in xml_root])
    tags = list(set([y for x in [[child.tag for child in block] for block in xml_root] for y in x] ))
    children = [{child_tag:[None if x.find(child_tag)==None else x.find(child_tag).text for x in xml_root]} for child_tag in tags]
    for dictionary in children:
        column = dictionary.keys()[0]
        xml_table[column] = dictionary[column]
    return xml_table
    
