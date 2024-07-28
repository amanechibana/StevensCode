############################################################
# Name: Amane Chibana 
# Pledge: I pledge my honor that I have abided by the Stevens Honor System. 
# CS115 Homework 1 
#  
############################################################

from math import factorial
from functools import reduce

def mult(x, y):
    """Returns the product of x and y""" 
    return x * y 

def factorial(n):
    """
    When n is not 0 the function calculates that number...
        Function takes number N, makes a list with range from 1 to the number(n+1 to include number N) 
        The reduce function takes the list and returns the product of all the numbers in the list
    but when n is 0 the function returns 1 because the factorial of 0 is 1 
    """
    if n >0:
        return reduce(mult, range(1,n+1))
    elif n==0:
        return 1 

def add(x, y):
    """Returns the sum value of x and y"""
    return x + y

def mean(L):
    """
    When list L contains 1 or more elements
        Reduce function adds together the list L with add function
        the result is divided by the number of elements of the list with len function and is returned
    if there are no elements in list L function returns 0
    """
    if len(L)>0:
        return reduce(add, L)/len(L)
    else:
        return 0
    
