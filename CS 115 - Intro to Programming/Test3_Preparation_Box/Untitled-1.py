def draw(n):
    for i in range(1,n+1):
        if i == 1 or i == n:
            print('*'*n)
        else:
            print("*"+" "*(n-2)+"*")

if __name__ =="__main__":
    n = int(input("Enter side lenght of square"))
    draw(n)




def __eq__(self,other):
    if self.name != other.name or self.genre != other.genre:
        return False:
    else:
        instEqual = True 
        if len(sortedSelf) != len(sortedother):
            return False
        else:
            for i in range(len(sortedSelf)):
                if sortedSelf[i].lower() != sortedOther[i].lower():
                    instEqual = False
                    break
                else:
                    return instEqual