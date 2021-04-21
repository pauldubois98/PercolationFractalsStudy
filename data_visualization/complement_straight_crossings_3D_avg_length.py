from complement_straight_crossingsData3D import *

def plot_set(n, max_d, r,g,b):
    for n,d in [(n,d) for d in range(1,max_d+1)]:
        print(n, d)
        f1 = data["n"]==n #filter
        df = data[f1]
        f2 = df["d"]==d #filter
        df = df[f2]
        x = df['p']
        y = df['ral']
        plt.plot(x, y, label='n^d='+str(n)+'^'+str(d), c=(1-r*d/max_d, 1-g*d/max_d, 1-b*d/max_d))




plt.figure(figsize=[8.4, 4.8])
plot_set(2, 4, 0,1,1)
plot_set(3, 2, 1,0,1)
plot_set(5, 1, 1,1,0)
plt.title("Length of straight crossing (when existing)")
plt.xlabel("Percolation probability")
plt.ylabel("Average length of straight crossings")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
plt.xlim(0,1)
plt.ylim(0.9,2.5)
plt.savefig("data_visualization/crossing_3D/complement_straight_crossing_length_3D.png", dpi=300)
plt.show()



plt.figure(figsize=[8.4, 4.8])
plot_set(2, 1, 0,1,1)
plot_set(3, 1, 1,0,1)
plot_set(5, 1, 1,1,0)
plot_set(6, 1, 1,0,0)
plot_set(7, 1, 0,1,0)
plot_set(8, 1, 0,0,1)
plot_set(9, 1, 1,1,1)
plot_set(10, 1, 0,1,1)
plot_set(11, 1, 1,0,1)
plot_set(12, 1, 1,1,0)
plot_set(13, 1, 1,0,0)
plot_set(14, 1, 0,1,0)
plot_set(15, 1, 0,0,1)
plot_set(20, 1, 1,1,1)
plot_set(25, 1, 0.5,0.5,0.5)
plt.title("Length of straight crossing (when existing)")
plt.xlabel("Percolation probability")
plt.ylabel("Average length of straight crossings")
plt.legend()
plt.xlim(0,1)
plt.ylim(0.9,2.5)
plt.savefig("data_visualization/crossing_3D/complement_straight_crossing_length_3D_bis.png", dpi=300)
plt.show()
