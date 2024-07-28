############################################################
# Name: Amane Chibana 
# Pledge: I pledge my honor that I have abided by the Stevens Honor System. 
# CS115 Lab 1
#  
############################################################

from math import factorial
from functools import reduce

def inverse(x):
    """
    takes parameter x and returns float 1/x, the inverse of the parameter
    """
    return float(1/x)

def add(x, y):
    """
    takes parameters x and y and returns added value. Used later for reduce function
    """
    return x+y

def e(n):
    """
    l1 is a list that from 1 to n+1 that calculates the factorial of each value in the taylor expansion
    l2 is a list that is the inverse of l1 which is each term in the taylor expansion
    the final statement returns one plus the sum of the taylor expansion
    """
    l1 = map(factorial, range(1,n+1)) 
    l2 = map(inverse, l1)
    return 1+(reduce(add, l2))


