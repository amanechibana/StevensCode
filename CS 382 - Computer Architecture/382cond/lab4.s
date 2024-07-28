/*
Author  : Amane Chibana
Pledge  : I pledge my honor that I have abided by the Stevens Honor System.
*/
.text
.global _start

_start:
    ADR X0, side_a         // load address to register X0 
    ADR X1, side_b         // load address to register X1 
    ADR X2, side_c         // load addres to register X2 
    LDR X3, side_a         // load data into X3 
    LDR X4, side_b         // load data into X4 
    LDR X5, side_c         // load data into X5 
    MUL X6, X3, X3         // multiply X3 X3 and store in X6 
    MUL X7, X4, X4         // multiply X4 X4 and store in X7 
    MUL X8, X5, X5         // multiply X5 X5 and store in X8 
    ADD X6, X6, X7         // add X6 and X7 and store in X6 
    CMP X6, X8             // compare X6 and X8 
    B.EQ equal             // jump to equal if X6 and X8 were equal 
    ADR X1, no             // load address to register X1 
    ADR X0, len_no         // load address to register X0 
    LDR X2, [X0]           // load data into X2
    MOV X8, 64             // setting destination to 64 for printing 
    MOV X0, 1              // setting destination to 1 to print 
    SVC 0                  // invoke system call 
    MOV X0, 0              // status <- 0 
    MOV X8, 93             // exit() is system call #93 
    SVC 0                  // invoke system call 
    
equal:
    ADR X1, yes            // load address to register X1 
    ADR X0, len_yes        // load address to register X0 
    LDR X2, [X0]           // load data into X2
    MOV X8, 64             // setting destination to 64 for printing 
    MOV X0, 1              // setting destination to 1 to print 
    SVC 0                  // invoke system call 
    MOV X0, 0              // status <- 0 
    MOV X8, 93             // exit() is system call #93 
    SVC 0                  // invoke system call 

.data
    side_a: .quad 3
    side_b: .quad 4
    side_c: .quad 5
    yes: .string "It is a right triangle.\n"
    len_yes: .quad . - yes // Calculate the length of string yes
    no: .string "It is not a right triangle.\n"
    len_no: .quad . - no // Calculate the length of string n


    