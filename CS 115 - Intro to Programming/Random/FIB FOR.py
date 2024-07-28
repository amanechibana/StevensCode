def fib(n):
    fib = [0,1]
    for i in range(2,n+1):
        fib.append(fib[-1]+fib[-2])
    return fib[n]

def poggers(n):
    for i in range(0,n):
        print('poggers')