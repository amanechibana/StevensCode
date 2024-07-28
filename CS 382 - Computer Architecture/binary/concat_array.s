/*  
   Name: Amane Chibana
   Pledge: I pledge my honor that I have abided by the Stevens Honor System. 
 */

.global concat_array

concat_array:
   SUB SP, SP, 56                   // allocate frame
   STR X30, [SP]                    // store X30 on the frame
   MOV X8, 0                        // set X8 to 0 for counter for each array index of argument
   MOV X10, 0                       // set X10 to 0 for counter for each byte in concat_array_outstr
   ADR X13, concat_array_outstr     // load address of concat_array_str into X13
   MOV X28, 0                       // set to 0 for clearing
   MOV X29, 0                       // set counter for clearing string loop

clearloop:
   STR X28, [X13,X29]               // set 8 bytes of concat_array_outstr to 0
   ADD X29, X29, 8                  // increment counter by 1
   CMP X29, 1024                    // if reached end of array end the loop
   B.EQ loadstr                     // jump to next part of code
   B clearloop                      // go back to loop through array

loadstr:
   MOV X11, 0                       // set X11 to 0, counter for each byte in a string, to be used in copystr        
   LDR X9, [X0, X8]                 // load in integer of X8th byte from argment array
   STR X0, [SP,8]                   // store argument array into frame
   STR X1, [SP,16]                  // store length of argument array in frame
   STR X8, [SP,24]                  // store X8 on frame
   STR X13, [SP,32]                 // store X13 on frame
   STR X10, [SP,40]                 // store X10 on frame
   STR X11, [SP,48]                 // store X11 on frame
   MOV X0, X9                       // set X0 as integer for input for itoascii function
   BL itoascii                      // branch and link to itoascii function 
   LDR X8, [SP,24]                  // restore X8
   LDR X13, [SP,32]                 // restore X13
   LDR X10, [SP, 40]                // restore X10
   LDR X11, [SP, 48]                // restore X11

copystr:
   LDRB W14, [X0,X11]               // load byte of string of the current index 
   STRB W14, [X13,X10]              // Store byte of W4 into the X2'th byte of X1(Increments with each loop)
   CBZ W14, next                    // if the digit is a null terminator branch to next for the next iteration
   ADD X11, X11, 1                  // increment X11 by 1, counter for each byte in string 
   ADD X10, X10, 1                  // increment X10 by 1, counter for each byte in the outstr
   B copystr                        // branch to copystr loop

next:
   MOV W14, ' '                     // set W14 to a space 
   STRB W14, [X13,X10]              // store space into the outstr
   ADD X10, X10, 1                  // increment X10 by 1, counter for each byte in the outstr 
   LDR X0, [SP, 8]                  // load original array of strings from frame
   LDR X1, [SP, 16]                 // load length of original array of strings from frame
   SUB X1, X1, 1                    // subtract 1 from the total length
   CBZ X1, exit                     // if length == 0 branch to the exit
   ADD X8, X8, 8                    // add 8 to X8, for the next index of original array of strings
   B loadstr                        // branch to loadstr loop(outer loop)

exit:
   LDR X30, [SP]                    // load return address from frame
   ADR X0, concat_array_outstr      // set X0 as the address to concat_array_outstr for output
   ADD SP, SP, 56                   // de-allocate frame 
   RET                              // return 

.data
    concat_array_outstr:  .fill 1024, 1, 0
