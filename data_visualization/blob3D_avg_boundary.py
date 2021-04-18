from blobData3D import *

def plot_set(n, max_d, r,g,b):
    for n,d in [(n,d) for d in range(1,max_d+1)]:
        print(n, d)
        f1 = data["n"]==n #filter
        df = data[f1]
        f2 = df["d"]==d #filter
        df = df[f2]
        x = df['p']
        y = df['avg_boundary']
        plt.plot(x, y, label='n^d='+str(n)+'^'+str(d), c=(1-r*d/max_d, 1-g*d/max_d, 1-b*d/max_d))


def plot_set2(ns, d):
    for n,d in [(n,d) for n in ns]:
        print(n, d)
        f1 = data["n"]==n #filter
        df = data[f1]
        f2 = df["d"]==d #filter
        df = df[f2]
        x = df['p']
        y = df['avg_boundary']
        plt.plot(x, y, label='n^d='+str(n)+'^'+str(d))


plt.figure(figsize=[8.4, 4.8])
plot_set(3, 2, 1,0,1)
plot_set(5, 1, 1,1,0)
plt.title("boundary of the boundary of the blob")
plt.xlabel("p")
plt.ylabel("Average blob boundary area")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
plt.xlim(0,1)
plt.savefig("data_visualization/blob_3D/blob_boundary_3D.png", dpi=300)
plt.show()


plt.figure(figsize=[8.4, 4.8])
plot_set2( [3, 5, 7, 9, 11, 13, 15], 1)
plt.title("boundary of the boundary of the blob")
plt.xlabel("p")
plt.ylabel("Average blob boundary area")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
plt.xlim(0,1)
plt.savefig("data_visualization/blob_3D/blob_boundary_3D_bis.png", dpi=300)
plt.show()
