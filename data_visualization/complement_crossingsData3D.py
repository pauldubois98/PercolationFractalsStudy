import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

data = pd.read_csv('data/complement_crossings_3D_50000.csv')

data = data.sort_values(["p", "d", "n"])
data["cp"] = data["nc"] / data["rep"]
data["max"] = data["rep"] * ((data["n"]**3)**data["d"])
data["density"] = (data['max'] - data["sq"]) / data['max']
data["al"] = data["lc"] / data["nc"]
data["ral"] = data["al"] / data["n"]**data["d"]


