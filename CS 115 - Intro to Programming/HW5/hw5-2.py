'''
Created on October 21, 2022
@author: Amane Chibana 
Pledge: I pledge my honor that I have abided by the Stevens Honor System.

CS115 - Hw 5 
'''

memoLucas = {}

def fast_lucas(n):
    '''Returns the nth Lucas number using the memoization technique
    shown in class and lab. The Lucas numbers are as follows:
    [2, 1, 3, 4, 7, 11, ...]'''
    if n in memoLucas:
        return memoLucas[n]
    elif n==0:
        return 2
    elif n==1:
        return 1
    else:
        memoLucas[(n)] = fast_lucas(n-1)+fast_lucas(n-2) 
        return fast_lucas(n-1)+fast_lucas(n-2)



memoChange = {}

def fast_change(amount, coins):
    '''Takes an amount and a list of coin denominations as input.
    Returns the number of coins required to total the given amount.
    Use memoization to improve performance.'''
    if (amount, tuple(coins)) in memoChange:
        return memoChange[(amount,tuple(coins))]
    elif amount == 0:
        return 0
    elif coins == []:
        return float("inf")
    elif amount < coins[0]:
        memoChange[(amount,tuple(coins))] = fast_change(amount,coins[1:])
        return fast_change(amount,coins[1:])
    else:
        useIt = 1 + fast_change(amount - coins[0],coins)
        loseIt = fast_change(amount, coins[1:])
        memoChange[(amount,tuple(coins))] = min(useIt, loseIt)
        return min(useIt, loseIt) 

# If you did this correctly, the results should be nearly instantaneous.
print(fast_lucas(3))  # 4
print(fast_lucas(5))  # 11
print(fast_lucas(9))  # 76
print(fast_lucas(24))  # 103682
print(fast_lucas(40))  # 228826127
print(fast_lucas(50))  # 28143753123

print(fast_change(131, [1, 5, 10, 20, 50, 100]))
print(fast_change(292, [1, 5, 10, 20, 50, 100]))
print(fast_change(673, [1, 5, 10, 20, 50, 100]))
print(fast_change(724, [1, 5, 10, 20, 50, 100]))
print(fast_change(888, [1, 5, 10, 20, 50, 100]))


