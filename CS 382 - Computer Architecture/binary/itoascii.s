/*  
   Name: Amane Chibana
   Pledge: I pledge my honor that I have abided by the Stevens Honor System. 
 */

.global itoascii

itoascii:
   SUB SP, SP, 8              // allocate frame 
   MOV X8, X0                 // set X8 as integer to convert
   ADR X0, buffer             // load address of buffer to X0(also for output)
   MOV X9, 10                 // set X9 to 10 for division in loop
   MOV X11, 0                 // set X11 to 0, counter for each byte in buffer

loop:
   MOV X10, X8                // copy value of integer to X10
   SDIV X8, X8, X9            // signed divide integer by 10
   MUL X8, X8, X9             // multiply integer by 10(gets rid of least significant number)
   SUB X10, X10, X8           // subtract new number without first digit from original number to difference
   SDIV X8, X8, X9            // redivide by 10 for next iteration
   ADD X10, X10, 48           // add 48 to convert to ascii version of number
   STR X10, [X0,X11]          // store in buffer at X11 position
   CBZ X8, endofloop          // if integer is the last digit then branch out of loop
   ADD X11, X11, 1            // add 1 to loop counter
   B loop                     // branch to loop

endofloop:
   ADD X11, X11, 1            // add 1 to counter
   STRB WZR, [X0,X11]         // store null terminator
   SUB X11, X11, 1            // subtract 1 from counter to prepare to reverse string
   MOV X12, 0                 // counter for reversing            

reverse: 
   LDRB W13, [X0, X11]        // load byte of string from X11(from the end)
   LDRB W14, [X0, X12]        // load byte of string from X12(from the start)
   STRB W13, [X0, X12]        // swapping char position 
   STRB W14, [X0, X11]        // swapping char position
   ADD X12, X12, 1            // add 1 from counter
   SUB X11, X11, 1            // subtract 1 from counter
   CMP X11, X12               // compare counters
   B.GT reverse               // if X11 is still greater than X12, continue the loop

exit:
   ADD SP, SP, 8              // de-allocate frame
   RET                        // return

.data
    buffer: .fill 128, 1, 0
