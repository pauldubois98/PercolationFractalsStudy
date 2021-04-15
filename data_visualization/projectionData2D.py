import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

data = pd.read_csv('data/projections_2D_50000.csv')

data = data.sort_values(["p", "d", "n"])




