import pandas as pd
import os
from sqlalchemy import create_engine

folder_path = 'C:\Users\sadma\source\repos\healthcare-revenue-cycle-management\datasets\EMR\hospital-a\departments.csv'
all_data = []

for file in os.listdir(folder_path):
    if file.endswith('.csv'):
        df = pd.read_csv(os.path.join(folder_path, file))
        all_data.append(df)

combined_df = pd.concat(all_data, ignore_index = True)