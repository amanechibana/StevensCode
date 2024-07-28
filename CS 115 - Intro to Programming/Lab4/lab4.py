"""
 Name: Amane Chibana 
 Pledge: I pledge my honor that I have abided by the Stevens Honor System. 
 CS115 Lab 4 - Knapsack 
"""

def valueCalc(capacity, itemList):
    """
    Takes the capacity and list of items and returns the total value of the optimal amount of stolen items
    """
    if capacity <= 0 or itemList == []:
        return 0
    elif itemList[0][0]>capacity:
        return valueCalc(capacity, itemList[1:])
    else:
        useIt = itemList[0][1] + valueCalc(capacity - itemList[0][0],itemList[1:])
        loseIt = valueCalc(capacity, itemList[1:])
        return max(useIt,loseIt)

def itemCalc(value,itemList,newList = []):
    """
    Takes the most optimal value, list of items and a new empty list. Returns newList containing the new list of items
    """
    if value == 0:
        return newList 
    elif itemList == []:
        return []
    else:
        if itemList[0][1] > value:
            return itemCalc(value,itemList[1:],newList)
        else:
            useIt = itemCalc(value - itemList[0][1],itemList[1:],newList + [itemList[0]])
            loseIt = itemCalc(value,itemList[1:],newList)
            return max(useIt,loseIt)
        
def knapsack(capacity, itemList):
    """
    Takes the capacity and itemList. Returns a new list containing the value of all the items and a list of all the items used. 
    """
    return [valueCalc(capacity, itemList)] + [itemCalc(valueCalc(capacity, itemList),itemList,newList=[])]

    
