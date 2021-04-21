from complement_crossingsData2D import *

def plot_set(n, max_d, r,g,b):
    for n,d in [(n,d) for d in range(1,max_d+1)]:
        print(n, d)
        f1 = data["n"]==n #filter
        df = data[f1]
        f2 = df["d"]==d #filter
        df = df[f2]
        x = df['p']
        y = df['cp']
        plt.plot(x, y, label='n^d='+str(n)+'^'+str(d), c=(1-r*d/max_d, 1-g*d/max_d, 1-b*d/max_d))

def plot_set2(ns, d):
    for n,d in [(n,d) for n in ns]:
        print(n, d)
        f1 = data["n"]==n #filter
        df = data[f1]
        f2 = df["d"]==d #filter
        df = df[f2]
        x = df['p']
        y = df['cp']
        plt.plot(x, y, label='n^d='+str(n)+'^'+str(d))



plt.figure(figsize=[8.4, 4.8])
plot_set(2, 8, 0,1,1)
plot_set(3, 5, 1,0,1)
plot_set(5, 3, 1,1,0)
plt.title("Empirical Non-Straight Crossing Probability")
plt.xlabel("p")
plt.ylabel("Non-straight crossing probability")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
plt.xlim(0,1)
#plt.xlim(0.6,1)
plt.savefig("data_visualization/crossing_2D/complement_crossing_proba_2D.png", dpi=300)
plt.show()



plt.figure(figsize=[8.4, 4.8])
plot_set(2 ,2, 1,1,0)
plot_set(3 ,2, 1,0,1)
plot_set(5 ,2, 0,1,1)
plot_set(7 ,2, 1,1,0)
plot_set(11,2, 1,0,1)
plot_set(13,2, 0,1,1)
plot_set(17,2, 1,1,1)
plt.title("Empirical Non-Straight Crossing Probability")
plt.xlabel("p")
plt.ylabel("Non-straight crossing probability")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
plt.xlim(0,1)
#plt.xlim(0.6,1)
plt.savefig("data_visualization/crossing_2D/complement_crossing_proba_2D_bis.png", dpi=300)
plt.show()



plt.figure(figsize=[8.4, 4.8])
plot_set2( [2, 3, 5, 7, 11, 13, 17, 20, 25, 50, 75, 100, 125, 150, 175, 200], 1)
plt.title("Empirical Non-Straight Crossing Probability")
plt.xlabel("p")
plt.ylabel("Non-straight crossing probability")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
plt.xlim(0,1)
#plt.xlim(0.6,1)
plt.savefig("data_visualization/crossing_2D/complement_crossing_proba_2D_ter.png", dpi=300)
plt.show()
