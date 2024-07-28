/*******************************************************************************
 * Name        : sieve.cpp
 * Author      : Amane Chibana
 * Date        : September 18, 2023
 * Description : Sieve of Eratosthenes
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/
#include <cmath>
#include <iomanip>
#include <iostream>
#include <sstream>

using namespace std;

class PrimesSieve
{
public:
    PrimesSieve(int limit);

    ~PrimesSieve()
    {
        delete[] is_prime_;
    }

    void display_primes() const;

private:
    // Instance variables
    bool *const is_prime_;
    const int limit_;
    int num_primes_, max_prime_;

    // Method declarations
    void sieve();
    static int num_digits(int num);
};

PrimesSieve::PrimesSieve(int limit) : is_prime_{new bool[limit + 1]}, limit_{limit}, num_primes_{0}, max_prime_{0}
{
    sieve();
}

void PrimesSieve::display_primes() const
{
    /*Displays all primes found, the number of primes and the maximum prime
    This function has two cases of output. If the primes can be fit on a single line the program will output with one space inbetween each output
    On multi line the display will align using setw */
    const int max_prime_width = num_digits(max_prime_), primes_per_row = 80 / (max_prime_width + 1);
    cout << "\n" << "Number of primes found: " << num_primes_ << endl;
    cout << "Primes up to " << limit_ << ":" << endl;

    int current_primes_per_row = 0;

    for (int i = 2; i <= limit_; i++)
    {
        if (i == max_prime_)
        {
            cout << setw(max_prime_width) << i;
            break;
        }
        
        if (limit_ < 101 && is_prime_[i])
        {
            cout << i << " ";
        }
        else if (is_prime_[i])
        {
            cout << setw(max_prime_width) << i;
            current_primes_per_row++;
            if (current_primes_per_row == primes_per_row)
            {
                cout << endl;
                current_primes_per_row = 0;
            }
            else
            {
                cout << " ";
            }
        }
    }
}

void PrimesSieve::sieve()
{
    /*finds all primes up to a number using sieve algorithm 
    Sets non prime values in is_prime_ to false and then counts number of true values in num_prime_ and finds the max_prime_*/

    //sets 0 and 1 to false and all other values of the is_prime_ to true 
    is_prime_[0] = false;
    is_prime_[1] = false;
    for (int i = 2; i <= limit_; i++)
    {
        is_prime_[i] = true;
    }

    int primecount = 0;
    int maxprime = 0;

    for (int i = 2; i <= sqrt(limit_); i++)
    {
        if (is_prime_[i])
        {
            for (int j = i * i; j <= limit_; j += i)
            {
                is_prime_[j] = false;
            }
        }
    }

    for (int i = 2; i <= limit_; i++)
    {
        if (is_prime_[i])
        {
            primecount++;
            if (maxprime < i)
            {
                maxprime = i;
            }
        }
    }
    num_primes_ = primecount;
    max_prime_ = maxprime;
}

int PrimesSieve::num_digits(int num)
{
    /*counts number of digits in int num*/
    int i;
    for (i = 0; num > 0; i++)
    {
        num = num / 10;
    }
    return i;
}

int main()
{
    cout << "**************************** "
         << "Sieve of Eratosthenes"
         << " ****************************" << endl;
    cout << "Search for primes up to: ";
    string limit_str;
    cin >> limit_str;
    int limit;

    // Use stringstream for conversion. Don't forget to #include <sstream>
    istringstream iss(limit_str);

    // Check for error.
    if (!(iss >> limit))
    {
        cerr << "Error: Input is not an integer." << endl;
        return 1;
    }
    if (limit < 2)
    {
        cerr << "Error: Input must be an integer >= 2." << endl;
        return 1;
    }

    // outputs sieve data. prime up to the limit 
    PrimesSieve out = PrimesSieve(limit);
    out.display_primes();
    return 0;
}
