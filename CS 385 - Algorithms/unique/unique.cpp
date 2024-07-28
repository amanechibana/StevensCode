/*******************************************************************************
 * Name        : unique.cpp
 * Author      : Amane Chibana
 * Date        : September 28, 2023
 * Description : Determining uniqueness of chars with int as bit vector.
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System. 
 ******************************************************************************/
#include <iostream>
#include <cctype>

using namespace std;

bool is_all_lowercase(const string &s) {
    //checks if every character is a lowercase letter. returns true if it is otherwise false
    for(auto& x: s){
        if(x <= '9'){
            return false;
        }
        if(isupper(x)){
            return false;
        }
    }
    return true; 
}

bool all_unique_letters(const string &s) {
    // checks if &s have all unqiue letters, if unique return true. else false 
    unsigned int vector = 0;
    unsigned int setter;

    for(auto& x : s){
        setter = 1 << (x - 'a');
        if(vector == (vector | setter)){
            return false;
        } 
        vector = vector | setter;
    }

    return true; 
}

int main(int argc, char * const argv[]) {
    // Calls other functions to produce correct output.

    if(argc == 1 || argc>2){
        cerr << "Usage: " << argv[0] << " <string>" << endl;
        return 1;
    }

    if(!(is_all_lowercase(argv[1]))){
        cerr << "Error: String must contain only lowercase letters." << endl;
        return 1;
    }

    if(all_unique_letters(argv[1])){
        cout<< "All letters are unique." << endl; 
    } else{
        cout << "Duplicate letters found." << endl;
    }

    return 0;
}
