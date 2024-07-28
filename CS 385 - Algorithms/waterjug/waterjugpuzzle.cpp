/*******************************************************************************
 * Name        : waterjugpuzzle.cpp
 * Author      : Amane Chibana, Madison Wong
 * Date        : 10/13/2023
 * Description : Water Jug Puzzle
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/
#include <iostream>
#include <sstream>
#include <string>
#include <stdlib.h> //for using 'atoi', which converts arg in argv to int that can be used in < or > if-statements
#include <queue>
#include <stack>
#include <typeinfo>
#include <set>
#include <vector>
using namespace std;

// Define state of Jugs A, B, and C, their direction, their amount poured, and parent node
struct State
{
  int a, b, c, amountPoured;
  string directions;
  State *parent;

  State(int _a, int _b, int _c, string _directions) : a{_a}, b{_b}, c{_c}, amountPoured{0}, directions{_directions}, parent{nullptr} {}

  // String representation of state in tuple form.
  string to_string()
  {
    ostringstream oss;
    oss << "(" << a << ", " << b << ", " << c << ")";
    return oss.str();
  }
};

// Takes the user's input and displays the solution to the water jug puzzle.
bool jug(int capA, int capB, int capC, int goalA, int goalB, int goalC)
{
  // Declare a 2D array with capA rows.
  bool **array = new bool *[capA + 1];

  // For each row, make an array of capB.
  for (int i = 0; i <= capA; i++)
  {
    array[i] = new bool[capB + 1];
    fill(array[i], array[i] + capB + 1, false);
  }

  vector<State *> statePointers; // Holds all State pointers

  queue<State *> q; // Queue for BFS

  State *s = new State(0, 0, capC, "Initial state.");  // Initial state always begins with A,B=0

  statePointers.push_back(s);  // Add initial state to vector
  q.push(s);  // Add initial state to queue

  while (!q.empty())
  {
    State *current = q.front();   // Current node
    q.pop();  // Remove current node

    if (current->a == goalA && current->b == goalB && current->c == goalC) // situation if goal state is found
    {
      stack<State *> out;  // Stack for output in reverse order

      while (current->parent != nullptr) // Trace to root
      {
        out.push(current);
        current = current->parent;
      }

      out.push(current);

      // Print the trace of BFS with the output format
      while (!out.empty())
      {
        current = out.top();
        out.pop();
        if (current->amountPoured == 0)
        {
          cout << current->directions << " " << current->to_string() << endl;
        }
        else if (current->amountPoured == 1)
        {
          cout << "Pour " << current->amountPoured << " gallon "
               << "from " << current->directions << " " << current->to_string() << endl;
        }
        else
        {
          cout << "Pour " << current->amountPoured << " gallons "
               << "from " << current->directions << " " << current->to_string() << endl;
        }
      }

      // Clear heap memory
      for (State *state : statePointers)
      {
        delete state;
      }

      for (int i = 0; i <= capA; i++)
      {
        delete[] array[i];
      }

      delete[] array;

      return true; // Solution found
    }
    if (array[current->a][current->b] == true)
    {
      continue; // pass to next iteration if array has already been visited
    }

    array[current->a][current->b] = true; // place into array to say its visited

    int newA, newB, newC, temp, poured; // the new water levels to input

    // Jug C to jug A
    if (current->a != capA || current->c != 0)
    {
      temp = capA - current->a;
      if (current->c >= temp)
      {
        newA = current->a + temp;
        newB = current->b;
        newC = current->c - temp;
        poured = temp;
      }
      else
      {
        newA = current->a + current->c;
        newB = current->b;
        poured = current->c;
        newC = 0;
      }

      State *x = new State(newA, newB, newC, "C to A.");
      x->amountPoured = poured;
      x->parent = current; // set new situation with current as parent
      statePointers.push_back(x);
      if (array[newA][newB] == false)
      {
        q.push(x); // push into queue
      }
    }

    // Jug B to jug A
    if (current->a != capA || current->b != 0)
    {
      temp = capA - current->a;
      if (current->b >= temp)
      {
        newA = current->a + temp;
        newB = current->b - temp;
        newC = current->c;
        poured = temp;
      }
      else
      {
        newA = current->a + current->b;
        poured = current->b;
        newB = 0;
        newC = current->c;
      }
      State *y = new State(newA, newB, newC, "B to A.");
      y->amountPoured = poured;
      y->parent = current; // set new situation with current as parent
      statePointers.push_back(y);
      if (array[newA][newB] == false)
      {
        q.push(y); // push into queue
      }
    }

    // Jug C to jug B
    if (current->b != capB || current->c != 0)
    {
      temp = capB - current->b;
      if (current->c >= temp)
      {
        newA = current->a;
        newB = current->b + temp;
        newC = current->c - temp;
        poured = temp;
      }
      else
      {
        newA = current->a;
        newB = current->b + current->c;
        poured = current->c;
        newC = 0;
      }

      State *z = new State(newA, newB, newC, "C to B.");
      z->amountPoured = poured;
      z->parent = current; // set new situation with current as parent
      statePointers.push_back(z);
      if (array[newA][newB] == false)
      {
        q.push(z); // push into queue
      }
    }

    // Jug A to jug B
    if (current->b != capB || current->a != 0)
    {

      temp = capB - current->b;
      if (current->a >= temp)
      {
        newA = current->a - temp;
        newB = current->b + temp;
        newC = current->c;
        poured = temp;
      }
      else
      {
        newB = current->b + current->a;
        poured = current->a;
        newA = 0;
        newC = current->c;
      }
      State *i = new State(newA, newB, newC, "A to B.");
      i->amountPoured = poured;
      i->parent = current; // set new situation with current as parent
      statePointers.push_back(i);
      if (array[newA][newB] == false)
      {
        q.push(i); // push into queue
      }
    }

    // Jug B to jug C
    if (current->c != capC || current->b != 0)
    {

      temp = capC - current->c;
      if (current->b >= temp)
      {
        newA = current->a;
        newB = current->b - temp;
        newC = current->c + temp;
        poured = temp;
      }
      else
      {
        newA = current->a;
        newC = current->b + current->c;
        poured = current->b;
        newB = 0;
      }

      State *o = new State(newA, newB, newC, "B to C.");
      o->amountPoured = poured;
      o->parent = current; // set new situation with current as parent
      statePointers.push_back(o);
      if (array[newA][newB] == false)
      {
        q.push(o); // push into queue
      }
    }

    // Jug A to jug C
    if (current->c != capC || current->a == 0)
    {

      temp = capC - current->c;
      if (current->a >= temp)
      {
        newA = current->a - temp;
        newB = current->b;
        newC = current->c + temp;
        poured = temp;
      }
      else
      {
        newC = current->c + current->a;
        newB = current->b;
        poured = current->a;
        newA = 0;
      }
      State *p = new State(newA, newB, newC, "A to C.");
      statePointers.push_back(p);
      p->amountPoured = poured;
      p->parent = current; // set new situation with current as parent
      if (array[newA][newB] == false)
      {
        q.push(p); // push into queue
      }
    }
  }

  for (State *state : statePointers)
  {
    delete state;
  }
  // Delete each row first.

  for (int i = 0; i <= capA; i++)
  {
    delete[] array[i];
  }
  // Delete the array itself.
  delete[] array;

  return false;
}

int main(int argc, char *const argv[])
{
  if (argc == 7)
  {

    // for the output in case of an error
    const char *arguments[7] = {"jug A", "jug B", "jug C", "jug A", "jug B", "jug C"};

    for (int i = 1; i < argc; i++)
    {
      int curr_arg;

      auto curr_arg_string = argv[i];

      istringstream iss(curr_arg_string);

      // not an int
      if (!(iss >> curr_arg))
      {
        if (i < 4)
        {
          cerr << "Error: Invalid capacity \'" << argv[i] << "\' for " << arguments[i - 1] << ".\n";
          return 1;
        }
        else
        {
          cerr << "Error: Invalid goal \'" << argv[i] << "\' for " << arguments[i - 1] << ".\n";
          return 1;
        }
      }
    }

    for (int i = 1; i < argc; i++)
    {
      int curr_arg;

      auto curr_arg_string = argv[i];

      istringstream iss(curr_arg_string);

      iss >> curr_arg;

      // not positive int
      if (i == 3 && curr_arg == 0)
      {
        cerr << "Error: Invalid capacity \'" << argv[i] << "\' for " << arguments[i - 1] << ".\n";
        return 1;
      }

      if (curr_arg < 0)
      {
        if (i < 4)
        {
          cerr << "Error: Invalid capacity \'" << argv[i] << "\' for " << arguments[i - 1] << ".\n";
          return 1;
        }
        else
        {
          cerr << "Error: Invalid goal \'" << argv[i] << "\' for " << arguments[i - 1] << ".\n";
          return 1;
        }
      }
    }

    for (int i = 1; i < argc; i++)
    {
      // if goal exceeds respective capacity
      int curr_arg;

      auto curr_arg_string = argv[i];

      istringstream iss(curr_arg_string);

      iss >> curr_arg;
      if (i > 3)
      {
        if (atoi(argv[i]) > atoi(argv[i - 3]))
        {
          cerr << "Error: Goal cannot exceed capacity of " << arguments[i - 1] << ".\n";
          return 1;
        }
      }
    }
    int total_goal = atoi(argv[4]) + atoi(argv[5]) + atoi(argv[6]);

    // if total is not equal to capacity of jug C
    if (atoi(argv[3]) != total_goal)
    {
      cerr << "Error: Total gallons in goal state must be equal to the capacity of jug C.\n";
      return 1;
    }
  }
  else
  {
    cerr << "Usage: ./waterjugpuzzle <cap A> <cap B> <cap C> <goal A> <goal B> <goal C>\n";
    return 1;
  }

  // all the arguments in array as integers
  int things[6];

  for (int i = 1; i < argc; i++)
  {
    int curr_arg;

    auto curr_arg_string = argv[i];

    istringstream iss(curr_arg_string);

    iss >> curr_arg;

    things[i - 1] = curr_arg;
  }

  // Call function to either display BFS trace for solution, or display No solution
  if (!(jug(things[0], things[1], things[2], things[3], things[4], things[5])))
  {
    cout << "No solution." << endl;
  }

  return 0;
}