/*******************************************************************************
 * Filename: sprt.cpp
 * Author  : Amane Chibana
 * Version : 1.0
 * Date    : September 6, 2023
 * Description: Computes the square root of a double using Newton's method
 * Pledge  : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/

#include <iostream>
#include <sstream>
#include <limits>
#include <iomanip>
using namespace std;

double sqrt(double num, double epsilon)
{
    /*function that calculates the square root of num. The algorithm is based off of Newton's method */
    if (num < 0)
    {
        return numeric_limits<double>::quiet_NaN();
    }
    else if (num == 0 || num == 1)
    {
        return num;
    }

    double last_guess = num;
    double next_guess = (last_guess + num / last_guess) / 2;

    while (!(abs(last_guess - next_guess) <= epsilon))
    {
        last_guess = next_guess;
        next_guess = (last_guess + num / last_guess) / 2;
    }
    return next_guess;
}

int main(int argc, char *argv[])
{
    /*main function, takes in either one or two commmand line arguments that are doubles. Calls sqrt to calculate the square root of the first argument using Newton's method*/

    double num, epsilon;
    istringstream iss;

    if (!(argc == 2 || argc == 3))
    {
        cerr << "Usage: " << argv[0] << " <value> [epsilon]" << endl;
        return 1;
    }
    else if (argc == 2)
    {
        epsilon = 1e-7;
    }
    else
    {
        iss.str(argv[2]);
        if (!(iss >> epsilon) || epsilon <= 0)
        {
            cerr << "Error: Epsilon argument must be a positive double." << endl;
            return 1;
        }
        iss.clear();
    }

    iss.str(argv[1]);

    if (!(iss >> num))
    {
        cerr << "Error: Value argument must be a double." << endl;
        return 1;
    }

    cout << fixed << setprecision(8) << sqrt(num, epsilon);

    return 0;
}