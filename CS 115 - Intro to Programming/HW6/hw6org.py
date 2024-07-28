'''
Created on October 28, 2022
@author: Amane Chibana
Pledge: I pledge my honor that I have abided by the Stevens Honor System. 
CS115 - Hw 6
'''
# Number of bits for data in the run-length encoding format.
# The assignment refers to this as k.
COMPRESSED_BLOCK_SIZE = 5

# Number of bits for data in the original format.
MAX_RUN_LENGTH = 2 ** COMPRESSED_BLOCK_SIZE - 1

# Do not change the variables above.
# Write your functions here. You may use those variables in your code.

from functools import reduce

def numToBinary(n):
    '''Precondition: integer argument is non-negative.
    Returns the string with the binary representation of non-negative integer n.
    If n is 0, the empty string is returned.'''
    if n == 0:
        return ""
    elif n%2 == 1:
        return numToBinary(n//2) + "1"
    else:
        return numToBinary(n//2) + "0"

def binaryToNum(s):
    '''Precondition: s is a string of 0s and 1s.
    Returns the integer corresponding to the binary representation in s.
    Note: the empty string represents 0.'''
    if s == "":
        return 0
    return int(s[0])*2**(len(s)-1) + binaryToNum(s[1:])

def counter(S):
    '''Takes binary string as input. Counts how many times in a row a number appears. Returns integer'''
    if S == "":
        return 0
    elif len(S) == 1:
        return 1
    elif S[0] == S[1]:
        return 1 + counter(S[1:])
    else:
        return 1

def compressReturn(S):
    '''Takes binary string as input. Outputs a new list filled with integers that count the length of the number of 0's and 1's'''
    if S == "":
        return []
    else:
        return [counter(S)] + compressReturn(S[counter(S):])

def lenAdjust(S):
    '''This function properly adjusts the size of each binary input to the COMPRESSED_BLOCK_SIZE. Then returns a new binary string with the necessary amount of 0's as output.'''
    if len(S) == COMPRESSED_BLOCK_SIZE:
        return S
    else:
        return '0'*(COMPRESSED_BLOCK_SIZE-len(S)) + S

def sizeAdjust(L):
    '''Takes input list of integers. If a number in the list is greater than the max run length, it will split up the number so that it is not as large. Outputs new list of integers with split numbers'''
    if L == []:
        return []
    elif L[0] > MAX_RUN_LENGTH:
        L[0] += -MAX_RUN_LENGTH
        return [MAX_RUN_LENGTH] + [0] + sizeAdjust(L)
    else:
        return [L[0]]+sizeAdjust(L[1:])

#320(64*5) is the largest number of bits compress can use to encode a 64-bit
#I found that compress can often lengthen the code instead of shorten. In the cases of the images of a pengiun, smile and five: the compression returned a value greater than 1 which means that the compressed output was longer than the uncompressed
#the Laicompress algorithm cannot exist because if you have to indicate that the bit has switched from 0 to 1 or 1 to 0 then the number of bits increase. The more switches that occur there will be more numbers and there will be binary inputs with lots of both 0 and 1

def compress(S):
    '''Takes string as input. Input is uncompressed string of binary numbers and returns compressed string of binary numbers'''
    if S == "":
        return ""
    elif S[0] == '1':
        return '0'*COMPRESSED_BLOCK_SIZE + reduce(lambda a,b: a+b,map(lenAdjust,map(numToBinary,sizeAdjust(compressReturn(S)))))
    else:
        return reduce(lambda a,b: a+b,map(lenAdjust,map(numToBinary,sizeAdjust(compressReturn(S)))))

def uncompress(C):
    '''Takes string as input. Input is a compressed string of binary numbers and returns uncompressed string of binary numbers'''
    if C == "":
        return ""
    elif len(C) <= COMPRESSED_BLOCK_SIZE:
        return "0"*binaryToNum(C)
    else:
        return "0"*binaryToNum(C[0:COMPRESSED_BLOCK_SIZE]) + "1"*binaryToNum(C[COMPRESSED_BLOCK_SIZE:2*COMPRESSED_BLOCK_SIZE]) + uncompress(C[2*COMPRESSED_BLOCK_SIZE:])

def compression(S):
    '''Takes string of binary numbers at input. Returns the ratio of the length of the compressed image compared to the original string of binary numbers as output'''
    return len(compress(S))/len(S)
