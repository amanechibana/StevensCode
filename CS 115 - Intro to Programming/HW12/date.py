'''
Created on 12/5/2022
@author:   Amane Chibana 
Pledge:    I pledge my honor that I have abided by the Stevens Honor System. 

CS115 - Hw 12 - Date class
'''
DAYS_IN_MONTH = (0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

class Date(object):
    '''A user-defined data structure that stores and manipulates dates.'''

    # The constructor is always named __init__.
    def __init__(self, month, day, year):
        '''The constructor for objects of type Date.'''
        self.month = month
        self.day = day
        self.year = year

    # The 'printing' function is always named __str__.
    def __str__(self):
        '''This method returns a string representation for the
           object of type Date that calls it (named self).

             ** Note that this _can_ be called explicitly, but
                it more often is used implicitly via the print
                statement or simply by expressing self's value.'''
        return '%02d/%02d/%04d' % (self.month, self.day, self.year)

    def __repr__(self):
        '''This method also returns a string representation for the object.'''
        return self.__str__()

    # Here is an example of a 'method' of the Date class.
    def isLeapYear(self):
        '''Returns True if the calling object is in a leap year; False
        otherwise.'''
        if self.year % 400 == 0:
            return True
        if self.year % 100 == 0:
            return False
        if self.year % 4 == 0:
            return True
        return False

    def copy(self): 
        '''Returns a new object with the same month, day, year 
           as the calling object (self).''' 
        dnew = Date(self.month, self.day, self.year) 
        return dnew 
    
    def equals(self, d2): 
        '''Decides if self and d2 represent the same calendar date, 
            whether or not they are the in the same place in memory.''' 
        return self.year == d2.year and self.month == d2.month and self.day == d2.day 

    def tomorrow(self):
        '''Changes self date to next day'''
        if self.day < DAYS_IN_MONTH[self.month]:
            self.day+=1
        else:
            if self.isLeapYear() and self.month == 2 and self.day < 29:
                self.day +=1
            else: 
                self.month+= 1
                self.day = 1
                if self.month > 12:
                    self.month = 1
                    self.year += 1

    def yesterday(self):
        '''Changes self date to day before'''
        if self.day>1:
            self.day-=1
        else:
            if self.isLeapYear() and self.month == 3 and self.day == 1:
                self.day = 29
                self.month-=1
            else:
                self.month-= 1
                if self.month == 0:
                    self.month = 12
                    self.year -= 1
                self.day = DAYS_IN_MONTH[self.month]
    

    def addNDays(self, N):
        '''Prints and changes self date to next day N times'''
        for i in range(N):
            print(self)
            self.tomorrow()
        print(self)

    def subNDays(self, N):
        '''Prints and changes self date to day before N times'''
        for i in range(N):
            print(self)
            self.yesterday()
        print(self)

    def isBefore(self, d2): 
        '''Checks if self is before the date of d2. If self is before d2 returns True otherwise false'''
        return self.year < d2.year or (self.year == d2.year and self.month < d2.month) or (self.year == d2.year and self.month==d2.month and self.day < d2.day)
    
    def isAfter(self, d2):
        '''Checks if self is after the date of d2. If self is after d2 returns True otherwise false'''
        return self.year > d2.year or (self.year == d2.year and self.month > d2.month) or (self.year == d2.year and self.month==d2.month and self.day > d2.day)
            
    def diff(self, d2):
        '''Calculates number of days between self and d2 and returns number.
        returns negative integer if self is before d2
        returns positive integer if self is after d2
        retuns 0 if self and d2 are the same date'''
        date1 = self.copy()
        count = 0
        if date1.isBefore(d2):
            while not(date1.equals(d2)):
                count-=1
                date1.tomorrow()
        else:
             while not(date1.equals(d2)):
                count+=1
                date1.yesterday()
        return count

    def dow(self):
        '''Checks what date self lands on and returns date''' 
        listOfDates = ['Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday','Monday', 'Tuesday']
        return listOfDates[(self.diff(Date(11,9,2011)))%7]

