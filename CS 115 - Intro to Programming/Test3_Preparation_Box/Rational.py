class Rational:
    def __init__(self,n,d):
        self.numerator = n
        self.denominator = d

    def __add__(self,other):
        newDenominator = self.denominator*other.denominator
        newNumerator = self.numerator*other.denominator + self.denominator*other.numerator
        return Rational(newNumerator, newDenominator)  

    def isZero(self):
        return self.numerator == 0

    def __eq__(self,other):
        return self.numerator*other.denominator == self.denominator*other.numerator

    def __ge__(self, other):
        return self.numerator*other.denominator >= self.denominator*other.numerator
    
    def __str__(self):
        return str(self.numerator) + "/" +  str(self.denominator)       