'''
Created on October 19, 2022
@author:Amane Chibana 
Pledge: I pledge my honor that I have abided by the Stevens Honor System. 

CS115 - Lab 6
'''
def isOdd(n):
    '''Returns whether or not the integer argument is odd.'''
    return n%2 != 0
    
#42 = 00101010
#For odd number the right most bit will be a 1 and for an even number the right most bit will be a 0 because the right most bit equals determines if there is a 1 added or not which determine if the number is even or odd
#When eliminating the least significant bit, the number becomes equal to half its original value and rounds down. 
#You can easily find the base-2 representation of N by repeatedly using integer division(by 2) on the number until N is 0. When the number is odd return a 1 and when its even return a 0.

def numToBinary(n):
    '''Precondition: integer argument is non-negative.
    Returns the string with the binary representation of non-negative integer n.
    If n is 0, the empty string is returned.'''
    if n == 0:
        return ""
    elif isOdd(n):
        return numToBinary(n//2) + "1"
    return numToBinary(n//2) + "0"

def binaryToNum(s):
    '''Precondition: s is a string of 0s and 1s.
    Returns the integer corresponding to the binary representation in s.
    Note: the empty string represents 0.'''
    if s == "":
        return 0
    return int(s[0])*2**(len(s)-1) + binaryToNum(s[1:])

def increment(s):
    '''Precondition: s is a string of 8 bits.
    Returns the binary representation of binaryToNum(s) + 1.'''
    if len(numToBinary(binaryToNum(s)+1)) < 8:
        return "0" * (8-len(numToBinary(binaryToNum(s)+1))) + numToBinary(binaryToNum(s)+1)
    elif len(numToBinary(binaryToNum(s)+1)) > 8:
        return numToBinary(binaryToNum(s)+1)[1:]
    return numToBinary(binaryToNum(s)+1)

def count(s, n):
    '''Precondition: s is an 8-bit string and n >= 0.
    Prints s and its n successors.'''
    if n == 0:
        print(s)
    else:
        print(s)
        count(increment(s), n-1)
            
#The ternary for 59 is '2012'. Similar to the binary conversion, you can use integer division(except this time by 3) until N = 0. Return the remainder(so 2,1 or 0) to create the converted ternary number. 
        
def numToTernary(n):
    '''Precondition: integer argument is non-negative.
    Returns the string with the ternary representation of non-negative integer
    n. If n is 0, the empty string is returned.'''
    if n == 0:
        return ""
    elif n%3 == 2:
        return numToTernary(n//3) + "2"
    elif n%3 == 1:
        return numToTernary(n//3) + "1"
    return numToTernary(n//3) + "0"

def ternaryToNum(s):
    '''Precondition: s is a string of 0s, 1s, and 2s.
    Returns the integer corresponding to the ternary representation in s.
    Note: the empty string represents 0.'''
    if s == "":
        return 0
    return int(s[0])*3**(len(s)-1) + ternaryToNum(s[1:])
