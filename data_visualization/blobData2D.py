import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

data = pd.read_csv('data/blob_2D_50000.csv')

data = data.sort_values(["p", "d", "n"])
data["side"] = data["n"]**(data["d"])
data["max"] = data["rep"] * (data["side"]**2)
data["avg_interior"] = (data["interior"] / data["rep"]) / ((data["n"]**data["d"])**2)
data["avg_boundary"] = data["boundary"] / data["rep"] / (data["n"]**data["d"])
data["rescale_dist"] = ((np.sqrt(2)/2) / ((np.sqrt(2)/2) - ((np.sqrt(2)/2)/(data["n"]**data["d"]))))
data["avg_dist"] = data["rescale_dist"] * (data["dist"] / data["rep"] / (data["n"]**data["d"]))
data["avg_step"] = data["step"] / data["rep"] / (data["n"]**data["d"])


