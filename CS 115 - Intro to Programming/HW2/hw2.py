'''
Created on 9/28/2022
@author: Amane Chibana and Madison Wong 
Pledge: I pledge my honor that I have abided by the Stevens Honor System. 
CS115 - Hw 2
'''
import sys
from functools import reduce

scrabbleScores = \
[ ['a', 1], ['b', 3], ['c', 3], ['d', 2], ['e', 1], ['f', 4], ['g', 2],
    ['h', 4], ['i', 1], ['j', 8], ['k', 5], ['l', 1], ['m', 3], ['n', 1],
    ['o', 1], ['p', 3], ['q', 10], ['r', 1], ['s', 1], ['t', 1], ['u', 1],
    ['v', 4], ['w', 4], ['x', 8], ['y', 4], ['z', 10] ]

Dictionary = ['a', 'am', 'at', 'apple', 'bat', 'bar', 'babble', 'can', 'foo',
            'spam', 'spammy', 'zzyzva']

def letterScore(letter, scorelist):
    """
    Takes a letter and returns score associated with letter
    """
    if letter == "":
        return 0
    if letter != scorelist[0][0]:
        return letterScore(letter,scorelist[1:])
    else:
        return scorelist[0][1]

def wordScore(S, scorelist):
    """
    Takes a word and returns the score of each letter in word added up 
    """
    if S == "":
        return 0
    else:
        return letterScore(S[0], scorelist) + wordScore(S[1:],scorelist)

def wordValues(words):
    """
    Takes lists of words and returns the same list of words but with their word scores 
    """
    if words == []:
        return []
    return [[words[0], wordScore(words[0], scrabbleScores)]] + wordValues(words[1:])

def dictionaryFilterFunction(letters):
    """
    Takes in a list of letters, main purpose to help run function dictionaryFilter 
    """
    def dictionaryFilter(word):
        """
        Takes in word, tests if word can be made. Returns true or false
        """
        if (type(word) == str):
            word = list(word)
        elif (word == []):
            return True
        elif (letters == []):
            return False
        
        if letters[0] in word:  
            word.remove(letters[0]) 
        return dictionaryFilterFunction(letters[1:])(word)
    return dictionaryFilter  

def scoreList(Rack):
    """
    Takes rack of letters and returns a list of possible words 
    """
    possibleDict = list(filter(dictionaryFilterFunction(Rack), Dictionary))
    return wordValues(possibleDict)

def bestWord(Rack):
    """
    Takes rack of letters and returns the best possible word that is possible to make 
    """
    if scoreList(Rack) == []:
        return ['', 0]
    else:
        return reduce(lambda a, b: a if a[1] > b[1] else b, scoreList(Rack))
