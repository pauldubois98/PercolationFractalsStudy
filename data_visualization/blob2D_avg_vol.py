from blobData2D import *

def plot_set(n, max_d, r,g,b):
    for n,d in [(n,d) for d in range(1,max_d+1)]:
        print(n, d)
        f1 = data["n"]==n #filter
        df = data[f1]
        f2 = df["d"]==d #filter
        df = df[f2]
        x = df['p']
        y = df['avg_interior']
        plt.plot(x, y, label='n^d='+str(n)+'^'+str(d), c=(1-r*d/max_d, 1-g*d/max_d, 1-b*d/max_d))


def plot(n, d, r,g,b):
    print(n, d)
    f1 = data["n"]==n #filter
    df = data[f1]
    f2 = df["d"]==d #filter
    df = df[f2]
    x = df['p']
    y = df['avg_interior']
    plt.plot(x, y, label='n^d='+str(n)+'^'+str(d), c=(1-r, 1-g, 1-b))


def plot_set2(ns, d):
    for n,d in [(n,d) for n in ns]:
        print(n, d)
        f1 = data["n"]==n #filter
        df = data[f1]
        f2 = df["d"]==d #filter
        df = df[f2]
        x = df['p']
        y = df['avg_interior']
        plt.plot(x, y, label='n^d='+str(n)+'^'+str(d))


plt.figure(figsize=[8.4, 4.8])
plot_set(3, 5, 1,0,1)
plot_set(5, 2, 1,1,0)
plt.title("Area of the blob")
plt.xlabel("p")
plt.ylabel("Average blob interior area")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
plt.xlim(0,1)
plt.ylim(0,1)
plt.savefig("data_visualization/blob_2D/blob_interior_2D.png", dpi=300)
plt.show()



plt.figure(figsize=[8.4, 4.8])
plot_set(3, 2, 1,0,1)
plot_set(5, 2, 1,1,0)
plot_set(7, 2, 1,0,0)
plot_set(11,2, 0,1,0)
plot_set(13,2, 0,0,1)
plot_set(17,2, 1,1,1)
plt.title("Area of the blob")
plt.xlabel("p")
plt.ylabel("Average blob interior area")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
plt.xlim(0,1)
plt.ylim(0,1)
plt.savefig("data_visualization/blob_2D/blob_interior_2D_bis.png", dpi=300)
plt.show()



plt.figure(figsize=[8.4, 4.8])
plot_set2( [3, 5, 7, 11, 13, 17, 25, 51, 75, 101, 125, 151, 175, 201], 1)
plt.title("Area of the blob")
plt.xlabel("p")
plt.ylabel("Average blob interior area")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
plt.xlim(0,1)
plt.ylim(0,1)
plt.savefig("data_visualization/blob_2D/blob_interior_2D_ter.png", dpi=300)
plt.show()



plt.figure(figsize=[8.4, 4.8])
plot(5, 2, 0,0.5,0.5)
plot(5*5, 1, 0,1,1)
plot(7, 2, 0,0,0.5)
plot(7*7, 1, 0,0,1)
plot(11, 2, 0,0.5,0)
plot(11*11, 1, 0,1,0)
plot(13, 2, 0.5,0,0)
plot(13*13, 1, 1,0,0)
plot(17, 2, 0.4,0.4,0.4)
plot(17*17, 1, 0.8,0.8,0.8)
plt.title("Area of the blob")
plt.xlabel("p")
plt.ylabel("Average blob interior area")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
plt.xlim(0,1)
plt.ylim(0,1)
plt.savefig("data_visualization/blob_2D/blob_interior_2D_qua.png", dpi=300)
plt.show()
