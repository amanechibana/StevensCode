/*******************************************************************************
 * Name        : stairclimber.cpp
 * Author      : Amane Chibana
 * Date        : September 5, 2023
 * Description : Lists the number of ways to climb n stairs.
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/
#include <iostream>
#include <vector>
#include <algorithm>
#include <sstream>
#include <iomanip>

using namespace std;

vector<vector<int>> get_ways(int num_stairs)
{
    /*finds possible ways to climb up a staircase of num_stairs. Returns vector of possible solutions*/
    if (num_stairs <= 0)
    {
        vector<vector<int>> out;
        out.push_back({});
        return out;
    }

    vector<vector<int>> ways;

    for (int i = 1; i < 4; i++)
    {
        if (num_stairs >= i)
        {
            vector<vector<int>> result = get_ways(num_stairs - i);
            for (auto x : result)
            {
                x.insert(x.begin(), i);
                ways.push_back(x);
            }
        }
    }

    return ways;
}

int num_digits(int num)
{
    /*counts number of digits in int num*/
    int i;
    for (i = 0; num > 0; i++)
    {
        num = num / 10;
    }
    return i;
}

void display_ways(const vector<vector<int>> &ways)
{
    /* Displays all possible solutions in vector ways. 
    labels are right-aligned to the width of the highest label*/
    for (long unsigned int i = 0; i < ways.size(); i++)
    {
        cout << setw(num_digits(ways.size())) << i + 1 << ". [";
        for (long unsigned int j = 0; j < ways[i].size(); j++)
        {
            if (j == ways[i].size() - 1)
            {
                cout << ways[i][j];
                break;
            }
            cout << ways[i][j] << ", ";
        }
        cout << "]" << endl;
    }
}

int main(int argc, char *const argv[])
{
    /* Calls get_ways() and display_ways() to properly display possible solutions. 
    Returns an error if progam is not called correctly*/
    int num;

    if (argc != 2)
    {
        cerr << "Usage: " << argv[0] << " <number of stairs>" << endl;
        return 1;
    }

    istringstream iss(argv[1]);

    if (!(iss >> num) || num <= 0)
    {
        cerr << "Error: Number of stairs must be a positive integer." << endl;
        return 1;
    }

    vector<vector<int>> ways = get_ways(num);
    if (num == 1)
    {
        cout << ways.size() << " way to climb " << num << " stair." << endl;
    }
    else
    {
        cout << ways.size() << " ways to climb " << num << " stairs." << endl;
    }
    display_ways(ways);
    return 0;
}
