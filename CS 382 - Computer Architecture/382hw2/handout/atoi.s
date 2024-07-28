/**
 * Name: Amane Chibana
 * Pledge: I pledge my honor that I have abided by the Stevens Honor System.
 */

.text
.global _start

_start:
    ADR X0, numstr          // load adress of numstr and store in X0
    MOV W3, 0               // set W3 to 0
    MOV W4, 10              // set W4 to 10
    MOV X5, 0               // set X5 to 0 


loop:
    LDRB W2, [X0,X5]        // load a X5th byte of X0 and store in W2
    CBZ W2, exit2           // if W2 is equal to 0 branch to exit2(check for null terminator)
    SUB W2, W2, 48          // subtract 48 from W2 and store in W2
    MUL W3, W3, W4          // multiply W3 and W4 and store in W4
    ADD W3, W3, W2          // add W3 and W2 and store and W3
    ADD X5, X5, 1           // increment X5 by 1(counter)
    B loop                  // branch to loop

exit2:
    ADR X0, number          // load address of number in X0
    STR W3, [X0]            // store W3(result) in X0


/* Do not change any part of the following code */
exit:
    MOV  X0, 1
    ADR  X1, number
    MOV  X2, 8
    MOV  X8, 64
    SVC  0
    MOV  X0, 0
    MOV  X8, 93
    SVC  0
    /* End of the code. */


/*
 * If you need additional data,
 * declare a .data segment and add the data here
 */






