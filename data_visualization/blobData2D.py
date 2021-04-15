import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

data = pd.read_csv('data/blob_2D_50000.csv')

data = data.sort_values(["p", "d", "n"])
data["side"] = data["n"]**(data["d"])
data["max"] = data["rep"] * (data["side"]**2)
#data["density"] = data["sq"] / data['max']
#data["dim"] = np.log(data["sq"]) / np.log(data["max"])
data["avg_vol"] = data["vol"] / data["rep"]
data["rel_avg_vol"] = data["avg_vol"] / (data["side"]**2)
data["avg_area"] = data["area"] / data["rep"]
data["rel_avg_area"] = data["avg_area"] / (data["side"])
data["avg_dist"] = data["dist"] / data["rep"]
data["rel_avg_dist"] = data["avg_dist"] / (data["side"])
data["avg_step"] = data["step"] / data["rep"]
data["rel_avg_step"] = data["avg_step"] / (data["side"])


