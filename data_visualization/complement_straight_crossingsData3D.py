import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

data = pd.read_csv('data/complement_crossings_straight_3D_50000.csv')

data = data.sort_values(["p", "d", "n"])
data["cp"] = data["nc"] / data["rep"]
data["max"] = data["rep"] * ((data["n"]**(data["d"]))**3)
data["density"] = data["sq"] / data['max']
data["dim"] = (np.log(data["max"]) - np.log(data["sq"])) / np.log(data["max"])
data["al"] = data["lc"] / data["nc"]
data["ral"] = data["al"] / data["n"]**data["d"]


