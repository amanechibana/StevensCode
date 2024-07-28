"""
 Name: Amane Chibana 
 Pledge: I pledge my honor that I have abided by the Stevens Honor System. 
 CS115 Lab 3 - Use it vs Lose it 
"""

def change(amount, coins):
    """
    takes the amount of change needed and the types of coins available. Returns the minimum number of coins required for change
    """
    if amount == 0:
        return 0
    elif coins == []:
        return float("inf")
    elif amount < coins[0]:
        return change(amount,coins[1:])
    else:
        useIt = 1 + change(amount - coins[0],coins)
        loseIt = change(amount, coins[1:])
        return min(useIt, loseIt) 
