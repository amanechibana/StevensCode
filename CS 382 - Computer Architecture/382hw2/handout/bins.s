/**
 * Name: Amane Chibana
 * Pledge: I pledge my honor that I have abided by the Stevens Honor System.
*/

 
.text
.global _start

_start:
    ADR X0, arr             //  load address of arr
    ADR X2, length          //  load address of length        
    LDR X1, [X2]            //  load data of length into X1
    ADR X4, target          //  load address of target in X4
    LDR X2, [X4]            //  load data of target in X2
    MOV X3, 0               //  set X3 to 0(min)
    SUB X4, X1, 1           //  set X4 to length-1(max)
    MOV X5, 0               //  set X5 to 0 (mid value for search)
    MOV X6, 2               //  set X6 to 2
    MOV X7, 0               //  set X7 to 0 
    MOV X8, 8               //  set X8 to 8

findmid:
    CMP X3, X4              //  compare X3 and X4 (min and max)
    B.GT false              //  if X3 is greater than X4 branch to false

    SUB X5, X4, X3          //  set X5 equal to subtract X4 from X3 
    SDIV X5, X5, X6         //  set X5 equal to divide X5 and X3
    ADD X5, X5, X3          //  set X5 equal to add X5 to X3 
    MUL X7, X8, X5          //  set X7 equal to multuply X8 and X5
    LDR X9, [X0, X7]        //  load data X0 from X7th byte to X9
    CMP X9, X2              //  compare X9 and X2
    B.EQ true               //  if X9 and X2 are equal branch to true
    B.GT less               //  if X9 is greater than X2 branch to less
    B.LT greater            //  if X9 is less than X2 branch to greater
    
less:
    SUB X4, X5, 1           //  set X4 to subtract 1 from X5(1 less than middle) 
    B findmid               //  branch to find mid (loop)

greater:
    ADD X3, X5, 1           //  set X3 to add 1 to X5(1 more than middle)
    B findmid               //  branch to find mid(loop)

false:
    ADR X1, msg2            //  set X1 to address of msg2 
    MOV X2, 28              //  set X2 to msg2 length
    MOV X8, 64              //  setting destination to 64 for printing 
    MOV X0, 1               //  setting destination to 1 to print 
    SVC 0                   //  invoke system call  

    MOV X0, 0               //  status <- 0 
    MOV X8, 93              //  exit() is system call #93 
    SVC 0                   //  invoke system call 

true:
    ADR X1, msg1            //  set X1 to address of msg2 
    MOV X2, 24              //  set X2 to msg2 length
    MOV X8, 64              //  setting destination to 64 for printing 
    MOV X0, 1               //  setting destination to 1 to print 
    SVC 0                   //  invoke system call 

    MOV X0, 0               //  status <- 0 
    MOV X8, 93              //  exit() is system call #93 
    SVC 0                   //  invoke system call

    

/*
 * If you need additional data,
 * declare a .data segment and add the data here
 */
