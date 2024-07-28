/**
 * Name: Amane Chibana
 * Pledge: I pledge my honor that I have abided by the Stevens Honor System.
*/

.text
.global _start

_start:
    ADR X0, src_str        // load address of src_str to X0
    ADR X1, dst_str        // load address of dst_str to X1
    MOV X2, 0              // set X2 to 0 (counter of loop)

loop:
    LDRB W4, [X0,X2]       // load X2'th byte of X0 to W4(Increments with each loop)
    STRB W4, [X1,X2]       // Store byte of W4 into the X2'th byte of X1(Increments with each loop)
    CMP W4, 0              // Compare W4 to 0, (check for null terminator)
    B.EQ exit              // if equal branch to exit
    ADD X2, X2, 1          // increment X2 by 1 
    B loop                 // branch to loop
    

exit:
    MOV X8, 64             // setting destination to 64 for printing 
    MOV X0, 1              // setting destination to 1 to print 
    SVC 0                  // invoke system call   
    MOV X0, 0              // status <- 0 
    MOV X8, 93             // exit() is system call #93 
    SVC 0                  // invoke system call 

/*
 * If you need additional data,
 * declare a .data segment and add the data here
 */

 
