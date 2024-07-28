import unittest
import solution as hw1 #change hw1sol to the name of your solution file

class Test(unittest.TestCase):
    def testFactorial(self):
        self.assertEqual(hw1.factorial(5), 120)
    def testFactorial1(self):
        self.assertEqual(hw1.factorial(1), 1)
    def testFactorial2(self):
        self.assertEqual(hw1.factorial(6), 720)
    def testFactorial3(self):
        self.assertEqual(hw1.factorial(2), 2)
    def testFactorial4(self):
        self.assertEqual(hw1.factorial(3), 6)
        
    def testMean(self):
        self.assertEqual(hw1.mean([1,2,3]),2)
    def testMean1(self):
        self.assertEqual(hw1.mean([1,1,1]),1)
    def testMean2(self):
        self.assertEqual(hw1.mean([5, 4]),4.5)
    def testMean3(self):
        self.assertEqual(hw1.mean([0,0,1]),0.3333333333333333)
    def testMean4(self):
        self.assertEqual(hw1.mean([]),0)

if __name__ == "__main__":
    unittest.main()
