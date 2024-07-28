/*******************************************************************************
 * Name        : inversioncounter.cpp
 * Author      : Amane Chibana
 * Version     : 1.0
 * Date        : October 29, 2023
 * Description : Counts the number of inversions in an array.
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/
#include <iostream>
#include <algorithm>
#include <sstream>
#include <vector>
#include <cstdio>
#include <cctype>
#include <cstring>

using namespace std;

// Function prototype.
static long mergesort(int array[], int scratch[], int low, int high);

/**
 * Counts the number of inversions in an array in Theta(n^2) time using two nested loops.
 */
long count_inversions_slow(int array[], int length)
{
    long inversions = 0;

    for (int i = 0; i < length; i++)
    {
        for (int j = i; j < length; j++)
        {
            if (array[i] > array[j])
            {
                inversions++;
            }
        }
    }
    return inversions;
}

/**
 * Counts the number of inversions in an array in Theta(n lg n) time.
 */
long count_inversions_fast(int array[], int length)
{
    int *scratch = new int[length];
    long out = mergesort(array, scratch, 0, length - 1);
    delete[] scratch;
    return out;
}

/*merge function to merge together two arrays for mergesort, returns inversion count*/
long merge(int array[], int scratch[], int low, int mid, int high)
{
    int i1 = low;
    int i2 = mid + 1;
    int i = low;
    long inversions = 0;

    while (i1 <= mid && i2 <= high)
    {
        if (array[i1] <= array[i2])
        {
            scratch[i++] = array[i1++];
        }
        else
        {
            scratch[i++] = array[i2++];
            inversions += mid - i1 + 1;
        }
    }

    for (int j = i1; j <= mid; j++)
    {
        scratch[i++] = array[i1++];
    }

    for (int j = i2; j <= high; j++)
    {
        scratch[i++] = array[i2++];
    }

    for (int j = low; j <= high; j++)
    {
        array[j] = scratch[j];
    }

    return inversions;
}

/*applies mergesort to array from low to high*/
static long mergesort(int array[], int scratch[], int low, int high)
{
    long inversions = 0;

    if (low < high)
    {
        int mid = low + (high - low) / 2;
        inversions += mergesort(array, scratch, low, mid);
        inversions += mergesort(array, scratch, mid + 1, high);
        inversions += merge(array, scratch, low, mid, high);
    }
    return inversions;
}

int main(int argc, char *argv[])
{

    if (argc > 2)
    {
        cerr << "Usage: " << argv[0] << " [slow]" << endl;
        return 1;
    }

    bool isSlow = false;

    if (argc == 2)
    {
        istringstream iss2(argv[1]);
        string isSlow2;
        if (iss2 >> isSlow2 && isSlow2 != "slow")
        {
            cerr << "Error: Unrecognized option '" << argv[1] << "'." << endl;
            return 1;
        }
        else
        {
            isSlow = true;
        }
    }

    cout << "Enter sequence of integers, each followed by a space: " << flush;

    istringstream iss;
    int value, index = 0;
    vector<int> values;
    string str;
    str.reserve(11);
    char c;
    while (true)
    {
        c = getchar();
        const bool eoln = c == '\r' || c == '\n';
        if (isspace(c) || eoln)
        {
            if (str.length() > 0)
            {
                iss.str(str);
                if (iss >> value)
                {
                    values.push_back(value);
                }
                else
                {
                    cerr << "Error: Non-integer value '" << str
                         << "' received at index " << index << "." << endl;
                    return 1;
                }
                iss.clear();
                ++index;
            }
            if (eoln)
            {
                break;
            }
            str.clear();
        }
        else
        {
            str += c;
        }
    }

    if (values.empty())
    {
        cerr << "Error: Sequence of integers not received." << endl;
        return 1;
    }

    long out;

    if (isSlow)
    {
        out = count_inversions_slow(&values[0], values.size());
        cout << "Number of inversions (slow): " << out << endl;
        return 0;
    }

    out = count_inversions_fast(&values[0], values.size());
    cout << "Number of inversions (fast): " << out << endl;
    return 0;
}
