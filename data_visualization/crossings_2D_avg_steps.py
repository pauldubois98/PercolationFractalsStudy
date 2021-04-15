from crossingsData2D import *

def plot_set(n, max_d, r,g,b):
    for n,d in [(n,d) for d in range(1,max_d+1)]:
        print(n, d)
        f1 = data["n"]==n #filter
        df = data[f1]
        f2 = df["d"]==d #filter
        df = df[f2]
        x = df['p']
        y = df['al']
        plt.plot(x, y, label='n^d='+str(n)+'^'+str(d), c=(1-r*d/max_d, 1-g*d/max_d, 1-b*d/max_d))

plot_set(2, 8, 0,1,1)
plot_set(3, 5, 1,0,1)
plot_set(5, 3, 1,1,0)
plot_set(7, 2, 1,1,0)
plot_set(11,2, 1,0,1)
plot_set(13,2, 0,1,1)
plot_set(17,2, 1,1,1)

plt.title("Non-Straight Crossing steps (when existing)")
plt.xlabel("p")
plt.ylabel("Average steps of crossings")
plt.legend()
plt.xlim(0,1)
#plt.xlim(0.6,1)
plt.show()
