/*******************************************************************************
 * Name        : shortestpaths.cpp
 * Author      : Amane Chibana and Takekuni Tanemori
 * Version     : 1.0
 * Date        : 12/3/2023
 * Description : Finds the shortest path between every vertex.
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/

#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>
#include <iomanip>
#include <limits>
#include <string>

using namespace std;

int num_vertices;

// counts the number of digits
int len(long num)
{
    if (num == 0)
    {
        return 1;
    }

    int count = 0;

    while (num > 0)
    {
        num = num / 10;
        count++;
    }
    return count;
}

string findPath(int i, int j, vector<vector<long>> intermediateVertices)
{
    long INF = numeric_limits<long>::max();
    string letter1;
    string letter2;
    letter1 += static_cast<char>(i + 'A');
    letter2 += static_cast<char>(j + 'A');

    if (i == j)
    {
        return letter1;
    }
    else if (intermediateVertices[i][j] == INF)
    {
        return " -> " + findPath(j, j, intermediateVertices);
    }
    else
    {
        return findPath(i, intermediateVertices[i][j], intermediateVertices) + findPath(intermediateVertices[i][j], j, intermediateVertices);
    }
}

// modified the matrix parameter type to be a 2D vector
void display_table(vector<vector<long>> matrix, const string &label,
                   const bool use_letters = false)
{
    long INF = numeric_limits<long>::max();
    cout << label << endl;
    long max_val = 0;
    for (int i = 0; i < num_vertices; i++)
    {
        for (int j = 0; j < num_vertices; j++)
        {
            long cell = matrix[i][j];
            if (cell < INF && cell > max_val)
            {
                max_val = matrix[i][j];
            }
        }
    }
    int max_cell_width = use_letters ? len(max_val) : len(max(static_cast<long>(num_vertices), max_val));
    cout << ' ';

    for (int j = 0; j < num_vertices; j++)
    {
        cout << setw(max_cell_width + 1) << static_cast<char>(j + 'A');
    }
    cout << endl;
    for (int i = 0; i < num_vertices; i++)
    {
        cout << static_cast<char>(i + 'A');
        for (int j = 0; j < num_vertices; j++)
        {
            cout << " " << setw(max_cell_width);
            if (matrix[i][j] == INF)
            {
                cout << "-";
            }
            else if (use_letters)
            {
                cout << static_cast<char>(matrix[i][j] + 'A');
            }
            else
            {
                cout << matrix[i][j];
            }
        }
        cout << endl;
    }
    cout << endl;
}

int main(int argc, const char *argv[])
{
    // Make sure the right number of command line arguments exist.
    if (argc != 2)
    {
        cerr << "Usage: " << argv[0] << " <filename>" << endl;
        return 1;
    }
    // Create an ifstream object.
    ifstream input_file(argv[1]);
    // If it does not exist, print an error message.
    if (!input_file)
    {
        cerr << "Error: Cannot open file '" << argv[1] << "'." << endl;
        return 1;
    }

    // Add read errors to the list of exceptions the ifstream will handle.
    input_file.exceptions(ifstream::badbit);
    string line;
    try
    {
        unsigned int line_number = 1;
        // Use getline to read in a line.
        // See http://www.cplusplus.com/reference/string/string/getline/
        getline(input_file, line);
        stringstream value(line);
        int numVert;
        vector<string> fileLines;
        string start;
        string end;
        string weight;

        // checks the validity of the first line
        if (!(value >> numVert) || numVert < 1 || numVert > 26)
        {
            cerr << "Error: Invalid number of vertices '" << line << "' on line 1." << endl;
            return 1;
        }
        else
        {
            fileLines.push_back(line);
            num_vertices = numVert;
            vector<vector<long>> distanceMatrix(num_vertices, vector<long>(num_vertices));
            vector<vector<long>> pathLengths(num_vertices, vector<long>(num_vertices));
            vector<vector<long>> intermediateVertices(num_vertices, vector<long>(num_vertices));
        }
        ++line_number;
        vector<vector<long>> distanceMatrix(num_vertices, vector<long>(num_vertices));
        vector<vector<long>> pathLengths(num_vertices, vector<long>(num_vertices));
        vector<vector<long>> intermediateVertices(num_vertices, vector<long>(num_vertices));

        long INF = numeric_limits<long>::max();
        // fills in all the matrices with default values
        for (int i = 0; i < num_vertices; i++)
        {
            for (int j = 0; j < num_vertices; j++)
            {
                // distance/path is 0 between the same vertices
                if (i == j)
                {
                    distanceMatrix[i][j] = 0;
                    pathLengths[i][j] = 0;
                }
                else
                {
                    distanceMatrix[i][j] = INF;
                    pathLengths[i][j] = INF;
                }
                intermediateVertices[i][j] = INF;
            }
        }

        // checks the start + end vertices and weight
        while (getline(input_file, line))
        {
            value.clear();
            stringstream value(line);
            // cout << line_number << ":\t" << line << endl;
            if (!(value >> start >> end >> weight))
            {
                cerr << "Error: Invalid edge data '" << line << "' on line " << line_number << "." << endl;
                return 1;
            }
            else
            {
                // fileLines.push_back(line);
                value >> start >> end >> weight;
                char s = start[0];
                char e = end[0];
                if (start.length() > 1 || s < 'A' || s > 'A' + num_vertices)
                {
                    cerr << "Error: Starting vertex '" << start << "' on line " << line_number << " is not among valid values " << 'A' << "-" << char('A' + num_vertices - 1) << "." << endl;
                    return 1;
                }
                else if (end.length() > 1 || e < 'A' || e > 'A' + num_vertices)
                {
                    cerr << "Error: Ending vertex '" << end << "' on line " << line_number << " is not among valid values " << 'A' << "-" << char('A' + num_vertices - 1) << "." << endl;
                    return 1;
                }
                else
                {
                    try
                    {
                        if (stoi(weight) <= 0)                  // chekcs if weight is greater than 0
                        {
                            cerr << "Error: Invalid edge weight '" << weight << "' on line " << line_number << "." << endl;
                            return 1;
                        }
                    }           
                    catch (const std::invalid_argument &e)      // checks if weight is not a string that cannot be integer
                    {
                        cerr << "Error: Invalid edge weight '" << weight << "' on line " << line_number << "." << endl;
                        return 1;
                    }
                    // fill in rest of matrix
                    int s = start[0];
                    int e = end[0];
                    distanceMatrix[s - 'A'][e - 'A'] = stoi(weight);
                    pathLengths[s - 'A'][e - 'A'] = stoi(weight);
                }
            }
            ++line_number;
        }

        // floyds algorithm
        for (int k = 0; k < numVert; k++)
        {
            for (int i = 0; i < numVert; i++)
            {
                for (int j = 0; j < numVert; j++)
                {
                    if (pathLengths[i][k] != INF && pathLengths[k][j] != INF)
                    {
                        if (pathLengths[i][k] + pathLengths[k][j] < pathLengths[i][j])
                        {
                            intermediateVertices[i][j] = k;
                            pathLengths[i][j] = pathLengths[i][k] + pathLengths[k][j];
                        }
                    }
                }
            }
        }

        // prints the tables
        display_table(distanceMatrix, "Distance matrix:");
        display_table(pathLengths, "Path lengths:");
        display_table(intermediateVertices, "Intermediate vertices:", true);


        // prints path
        for (int i = 0; i < numVert; i++)
        {
            for (int j = 0; j < numVert; j++)
            {
                if (pathLengths[i][j] == INF)
                {
                    cout << (char)('A' + i) << " -> " << (char)('A' + j) << ", distance: "
                         << "infinity, path: none" << endl;
                }
                else if (i == j)
                {
                    cout << (char)('A' + i) << " -> " << (char)('A' + j) << ", distance: " << pathLengths[i][j] << ", path: " << (char)('A' + i) << endl;
                }
                else
                {
                    cout << (char)('A' + i) << " -> " << (char)('A' + j) << ", distance: " << pathLengths[i][j] << ", path: " << (char)('A' + i) << findPath(i, j, intermediateVertices) << endl;
                }
            }
        }

        // Don't forget to close the file.
        input_file.close();
    }
    catch (const ifstream::failure &f)
    {
        cerr << "Error: An I/O error occurred reading '" << argv[1] << "'.";
        return 1;
    }

    return 0;
}
