# input 21 output 3 input 32 output 5 
def addTwoDigits(n):
    return n//10 + n%10

# input 2 output 99 input 3 output 999
def largestNumber(n):
    return 10**n-1

#step value of -1 going reverse 
def reverse(l):
    return l[::-1]

"""
map(function, list)

1 parameter
all values 

reduce(function, list)

2 parameter
single value

filter(function, list)

boolean
"""

def reverseString(string):
    return string[::-1]

def reverseStringRecursion(string):
    if string == "":
        return " "
    else:
        return string[-1] + reverseStringRecursion(string[:-1])
