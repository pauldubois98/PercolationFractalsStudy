from intersectionData2D import *
import numpy as np

def plot_set(n, d, a_min, a_max, step=2):
    for a in range(int(a_min/2)+4, int(a_max/2)+5, step):
        print(n, d, 2*a-8)
        f1 = data["n"]==n #filter
        df = data[f1]
        f2 = df["d"]==d #filter
        df = df[f2]
        x = df['p']
        maxi = 1/np.cos((2*a-8)*np.pi/180)
        y = df.iloc[:, a]/maxi
        plt.plot(x,y, label='a='+str(2*a-8))
    plt.title("Relative Intersection Length\n"+'n^d='+str(n)+'^'+str(d))
    plt.xlabel("p")
    plt.ylabel("Average Relative Intersection Length")
    plt.legend()
    plt.xlim(0,1)
    plt.ylim(0,1)
    #plt.show()
    plt.savefig("imgs/intersection_2D/relative_intersection_2D_"+'n^d='+str(n)+'^'+str(d)+".png")
    plt.figure()


plot_set(2, 1, 0,45, 2)
plot_set(2, 2, 0,45, 2)
plot_set(2, 3, 0,45, 2)
plot_set(2, 4, 0,45, 2)
plot_set(2, 5, 0,45, 2)
plot_set(2, 6, 0,45, 2)
plot_set(2, 7, 0,45, 2)
plot_set(2, 8, 0,45, 2)


plot_set(3, 1, 0,45, 2)
plot_set(3, 2, 0,45, 2)
plot_set(3, 3, 0,45, 2)
plot_set(3, 4, 0,45, 2)
plot_set(3, 5, 0,45, 2)

plot_set(5, 1, 0,45, 2)
plot_set(5, 2, 0,45, 2)
plot_set(5, 3, 0,45, 2)

plot_set(7, 1, 0,45, 2)
plot_set(7, 2, 0,45, 2)

plot_set(11, 1, 0,45, 2)
plot_set(11, 2, 0,45, 2)

plot_set(13, 1, 0,45, 2)
plot_set(13, 2, 0,45, 2)

plot_set(17, 1, 0,45, 2)
plot_set(17, 2, 0,45, 2)

plot_set(20, 1, 0,45, 2)
plot_set(25, 1, 0,45, 2)
plot_set(50, 1, 0,45, 2)
plot_set(75, 1, 0,45, 2)
plot_set(100, 1, 0,45, 2)
plot_set(125, 1, 0,45, 2)
plot_set(150, 1, 0,45, 2)
plot_set(175, 1, 0,45, 2)
plot_set(200, 1, 0,45, 2)



