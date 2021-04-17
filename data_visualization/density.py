import numpy as np
import matplotlib.pyplot as plt

for D in range(1,6):
    plt.figure(figsize=[8.4, 4.8])
    def plot_density(d, c):
        p = np.linspace(0,1,250)
        dim = p**d
        
        plt.plot(p, dim, label='n^d=n^'+str(d), c='C'+str(c))


    for c,d in enumerate([0,1,2,3,4,5,10,20,50,100]):
        plot_density(d,c)

    plt.title("Density of the percolation")
    plt.xlabel("p")
    plt.ylabel("Expected density")
    plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
    plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
    plt.xlim(0,1)
    plt.savefig("data_visualization/percolation/density_"+str(D)+"D.png", dpi=300)
    plt.show()
