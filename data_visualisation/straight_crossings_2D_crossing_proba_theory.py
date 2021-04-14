from straight_crossingsData2D import *
import numpy as np


def proba_th(n,d,p):
    return (n**d)*(p**((n**(d+1)-n)/(n-1)))

def data(n,d):
    Px = np.linspace(0,1,100)
    Py = np.zeros(100)
    for i,p in enumerate(Px):
        s=1
        for j in range(1,d+1):
            s *= n * (p**(n**j))
        Py[i] = s/(n**d)
    return Px, Py


def plot_set(n, max_d, r,g,b):
    for n,d in [(n,d) for d in range(1,max_d+1)]:
        x,y = data(n,d)
        plt.plot(x, y, label='n^d='+str(n)+'^'+str(d), c=(1-r*d/max_d, 1-g*d/max_d, 1-b*d/max_d))

def plot_set2(ns, d):
    for n,d in [(n,d) for n in ns]:
        x,y = data(n,d)
        plt.plot(x, y, label='n^d='+str(n)+'^'+str(d))



plt.figure(figsize=[8.4, 4.8])
plot_set(2, 2, 0,1,1)
plot_set(3, 2, 1,0,1)
plot_set(5, 2, 1,1,0)
plt.title("Theoretical Straight Crossing Probability")
plt.xlabel("p")
plt.ylabel("Straight Crossing Probability")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
plt.xlim(0,1)
#plt.xlim(0.6,1)
plt.savefig("imgs/crossing_2D/theoretical_straight_crossing_proba_2D.png")
plt.show()



plt.figure(figsize=[8.4, 4.8])
plot_set(2 ,2, 1,1,0)
plot_set(3 ,2, 1,0,1)
plot_set(5 ,2, 0,1,1)
plot_set(7 ,2, 0,0,1)
plot_set(11,2, 0,1,0)
plot_set(13,2, 1,0,0)
plot_set(17,2, 1,1,1)
plt.title("Theoretical Straight Crossing Probability")
plt.xlabel("p")
plt.ylabel("Straight Crossing Probability")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
plt.xlim(0,1)
#plt.xlim(0.6,1)
plt.savefig("imgs/crossing_2D/theoretical_straight_crossing_proba_2D_bis.png")
plt.show()



plt.figure(figsize=[8.4, 4.8])
plot_set2( [2, 3, 5, 7, 11, 13, 17, 20, 25, 50, 75, 100, 125, 150, 175, 200], 1)
plt.title("Theoretical Straight Crossing Probability")
plt.xlabel("p")
plt.ylabel("Straight Crossing Probability")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.subplots_adjust(left=0.1, right=0.75, top=0.9, bottom=0.1)
plt.xlim(0,1)
#plt.xlim(0.6,1)
plt.savefig("imgs/crossing_2D/theoretical_straight_crossing_proba_2D_ter.png")
plt.show()
