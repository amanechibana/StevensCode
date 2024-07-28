'''
Created on October 10, 2022 
@author: Amane Chibana
Pledge: I pledge my honor that I have abided by the Stevens Honor System. 

CS115 - Hw 3
'''

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' PROBLEM 0
' Implement the function giveChange() here:
' See the PDF in Canvas for more details.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
def giveChange(amount, coins):
    """
    takes the amount of change needed and the types of coins available. Returns the minimum number of coins required for change
    """
    if amount == 0:
        return [0, []]
    elif coins == []:
        return [float("inf"), []]
    elif coins[0] > amount:
        return giveChange(amount, coins[1:])
    else:
        recursive = giveChange(amount - coins[0], coins)
        useIt= [recursive[0] + 1, [coins[0]] + recursive[1]]
        loseIt = giveChange(amount, coins[1:])
        if useIt[0] > loseIt[0]:
            return loseIt
        else:
            return useIt

scrabbleScores = \
   [ ['a', 1], ['b', 3], ['c', 3], ['d', 2], ['e', 1], ['f', 4], ['g', 2],
     ['h', 4], ['i', 1], ['j', 8], ['k', 5], ['l', 1], ['m', 3], ['n', 1],
     ['o', 1], ['p', 3], ['q', 10], ['r', 1], ['s', 1], ['t', 1], ['u', 1],
     ['v', 4], ['w', 4], ['x', 8], ['y', 4], ['z', 10] ]

Dictionary = ['a', 'am', 'at', 'apple', 'bat', 'bar', 'babble', 'can', 'foo',
              'spam', 'spammy', 'zzyzva']

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' PROBLEM 1
' Implement wordsWithScore() which is specified below.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
def letterScore(letter, scorelist):
    '''Takes a letter and returns score associated with letter'''
    if letter == "":
        return 0
    if letter != scorelist[0][0]:
        return letterScore(letter,scorelist[1:])
    else:
        return scorelist[0][1]

def wordScore(S, scorelist):
    '''Takes a word and returns the score of each letter in word added up'''
    if S == "":
        return 0
    else:
        return letterScore(S[0], scorelist) + wordScore(S[1:],scorelist)

def wordsWithScore(dct, scores):
    '''List of words in dct, with their Scrabble score.

    Assume dct is a list of words and scores is a list of [letter,number]
    pairs. Return the dictionary annotated so each word is paired with its
    value. For example, wordsWithScore(Dictionary, scrabbleScores) should
    return [['a', 1], ['am', 4], ['at', 2] ...etc... ]
    '''
    if dct == []:
        return []
    else:
        return [[dct[0],wordScore(dct[0],scores)]] + wordsWithScore(dct[1:],scores)


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' PROBLEM 2
' For the sake of an exercise, we will implement a function
' that does a kind of slice. You must use recursion for this
' one. Your code is allowed to refer to list index L[0] and
' also use slice notation L[1:] but no other slices.
' (Notice that you cannot assume anything about the length of the list.)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
def take(n, L):
    '''Returns the list L[0:n], assuming L is a list and n is at least 0.'''
    if n == 0 or L ==[]:
        return []
    else:
        return [L[0]] + take(n-1,L[1:])

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' PROBLEM 3
' Similar to problem 2, will implement another function
' that does a kind of slice. You must use recursion for this
' one. Your code is allowed to refer to list index L[0] and
' also use slice notation L[1:] but no other slices.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
def drop(n, L):
    '''Returns the list L[n:], assuming L is a list and n is at least 0.'''
    if n == 0:
        return L
    else:
        return drop(n-1,L[1:]) 


