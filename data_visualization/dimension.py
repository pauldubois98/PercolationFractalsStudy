import numpy as np
import matplotlib.pyplot as plt

for D in range(1,6):
    plt.figure(figsize=[8.4, 4.8])
    def plot_dimension(n, c):
        p = np.linspace(0,1,250)
        dim = np.maximum(D + (np.log(p)/np.log(n)), 0*p)
        
        plt.plot(p, dim, label='n^d='+str(n)+'^$\infty$', c='C'+str(c))



    plot_dimension(2, 0)
    plot_dimension(3, 1)
    plot_dimension(5, 2)
    plot_dimension(6, 3)
    plot_dimension(7, 4)
    plot_dimension(8, 5)
    plot_dimension(9, 6)
    plot_dimension(10, 7)
    plot_dimension(20, 8)
    plot_dimension(50, 9)
    #plot_dimension(100, 10)
    #plot_dimension(250, 11)

    plt.title("Dimension of the percolation")
    plt.xlabel("p")
    plt.ylabel("Expected dimension")
    plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
    plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
    plt.xlim(0,1)
    plt.savefig("data_visualization/percolation/dimension_"+str(D)+"D.png", dpi=300)
    plt.show()
