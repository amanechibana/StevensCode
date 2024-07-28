from functools import reduce
def dbl(x):
    return 2*x

def add(x,y):
    return x+y

print(reduce(add, [1, 2, 3, 4]))

def gauss(n):
    return reduce(add, range(n+1))

print(gauss(5))


#(n+1)*(n/2)
