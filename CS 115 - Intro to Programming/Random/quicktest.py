from functools import reduce

def AddTwoDigits(n):
    return n//10 + n%10

def largestNumber(n):
    return 10**n-1

def reverse(l):
    return l[::-1]

def mySum(l):
    return reduce(lambda x, y: x + y, l)

def reverseString(string):
    if string == "":
        return ""
    else:
        return string[-1]+reverseString(string[:-1])

def prime(n):
    return len(list(filter(lambda x: n%x==0, range(2,n)))) == 0

def reverseString2(string):
    return string[::-1]
