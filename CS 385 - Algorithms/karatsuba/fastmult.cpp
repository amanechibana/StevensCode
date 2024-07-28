/*******************************************************************************
 * Name        : fastmult.cpp
 * Author      : Amane Chibana
 * Date        : November 12, 2023
 * Description : Use Karatsuba algorithm to calculate multiplication of large numbers
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/
#include <iostream>
#include <string>
#include <cmath>
using namespace std;

// pad the numbers with 0 to have length of powers of two
void padNum(string &a, string &b)
{
    int lengthToPad = pow(2, ceil(log2(max(a.length(), b.length()))));

    a.insert(a.begin(), lengthToPad - a.length(), '0');
    b.insert(b.begin(), lengthToPad - b.length(), '0');
}

// pad the numbers with 0 to the greatest length of the two
void padMax(string &a, string &b)
{
    int lengthToPad = max(a.length(), b.length());

    a.insert(a.begin(), lengthToPad - a.length(), '0');
    b.insert(b.begin(), lengthToPad - b.length(), '0');
}

// remove padding
void removePad(string &a)
{
    int i = 0;
    while (a[i] == '0')
    {
        i++;
    }
    a.erase(0, i);
}

// add two strings together
string add(const string &a, const string &b)
{
    int carry = 0;

    string out;

    for (int i = a.length() - 1; i >= 0; i--)
    {
        int total = a.at(i) + b.at(i) + carry - '0' - '0';
        carry = 0;

        if (total > 9)
        {
            carry += 1;
            total -= 10;
        }

        out.insert(out.begin(), total + '0');
    }

    if (carry)
    {
        out.insert(out.begin(), carry + '0');
    }

    return out;
}

// subtract two strings
string subtract(const string &a, const string &b)
{
    int carry = 0;

    string out;

    for (int i = a.length() - 1; i >= 0; i--)
    {
        int total = a.at(i) - b.at(i) - carry;
        carry = 0;

        if (total < 0)
        {
            carry = 1;
            total += 10;
        }

        out.insert(out.begin(), total + '0');
    }

    return out;
}

// karatsuba multiplication with strings
string multiply(const string &a, const string &b)
{
    string copyA = a;
    string copyB = b;
    padNum(copyA, copyB);

    int length = copyA.length();
    if (length == 1)
    {
        return to_string((a.at(0) - '0') * (b.at(0) - '0'));
    }

    int halfLength = length / 2;

    string a1 = copyA.substr(0, halfLength);
    string a2 = copyA.substr(halfLength);
    string b1 = copyB.substr(0, halfLength);
    string b2 = copyB.substr(halfLength);

    string c2 = multiply(a1, b1);
    string c0 = multiply(a2, b2);
    string c13 = multiply(add(a1, a2), add(b1, b2));

    padMax(c2, c0);
    string c14 = add(c2, c0);

    padMax(c13, c14);
    string c1 = subtract(c13, c14);

    c2 += string(length, '0');
    c1 += string(halfLength, '0');

    padMax(c1, c2);
    string result = add(c1, c2);

    padMax(result, c0);
    result = add(result, c0);

    removePad(result);
    return result;
}

int main(int argc, char *const argv[])
{
    cout << multiply(argv[1], argv[2]) << endl;

    return 0;
}