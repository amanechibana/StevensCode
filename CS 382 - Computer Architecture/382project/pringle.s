/* 
   Name: Amane Chibana
   Pledge: I pledge my honor that I have abided by the Stevens Honor System. 
 */

 /* Please grade extra credit */

.global pringle

pringle:
   SUB SP, SP, 120                     // allocate frame 
   STR X30, [SP]                       // store X30 on stack
   STR X0, [SP,8]                      // store arguments 0-7 on stack 
   STR X1, [SP,64]                     // store arguments 0-7 on stack 
   STR X2, [SP,72]                     // store arguments 0-7 on stack 
   STR X3, [SP,80]                     // store arguments 0-7 on stack 
   STR X4, [SP,88]                     // store arguments 0-7 on stack 
   STR X5, [SP,96]                     // store arguments 0-7 on stack 
   STR X6, [SP,104]                    // store arguments 0-7 on stack 
   STR X7, [SP,112]                    // store arguments 0-7 on stack  
   MOV X10, 0                          // set counter for original string 
   MOV X11, 1                          // set counter for original string + 1
   MOV X12, 0                          // set counter for outstring 
   MOV X13, X0                         // move original string to X13
   ADR X14, outstr                     // load address of outstring into X14
   MOV X16, 64                         // set counter for arguments on X16

loop:
   LDRB W15, [X13,X10]                 // load in character from original string 
   CMP W15, '%'                        // check for format specifier 
   B.EQ placestring                    // if equal to '%' branch
   STRB W15, [X14,X12]                 // store character in outstring 
   CBZ W15, exit                       // if null terminator then branch to exit 
   ADD X10, X10, 1                     // increment counter for original string
   ADD X11, X11, 1                     // increment counter for original string + 1
   ADD X12, X12, 1                     // increment counter for outstring 
   B loop                              // repeat loop

placestring:
   LDRB W15, [X13,X11]                 // load next character
   CMP W15, 'a'                        // check if its 'a' to make sure its format specifier
   B.NE next                           // branch to loop if not format specifier 
   B addarg                            // branch to adding arguments 

next:
   LDRB W15, [X13,X10]                 // load % if not format specifier
   STRB W15, [X14,X12]                 // store into out string 
   ADD X10, X10, 1                     // increment counter for original string
   ADD X11, X11, 1                     // increment counter for original string+1
   ADD X12, X12, 1                     // increment counter for output string 
   B loop                              // branch back into loop

addarg:                  
   LDR X0, [SP,X16]                    // load integer array 
   ADD X16, X16, 8                     // add 8 to counter for next argument
   LDR X1, [SP,X16]                    // load length of array
   ADD X16, X16, 8                     // add 8 to counter for next argument for next iteration 
   STR X10, [SP, 16]                   // store X10-X16 in stack
   STR X11, [SP, 24]                   // store X10-X16 in stack
   STR X12, [SP, 32]                   // store X10-X16 in stack
   STR X13, [SP, 40]                   // store X10-X16 in stack
   STR X14, [SP, 48]                   // store X10-X16 in stack
   STR X16, [SP, 56]                   // store X10-X16 in stack
   BL concat_array                     // call concat_array
   LDR X10, [SP, 16]                   // restore X10-X16 from stack
   LDR X11, [SP, 24]                   // restore X10-X16 from stack
   LDR X12, [SP, 32]                   // restore X10-X16 from stack
   LDR X13, [SP, 40]                   // restore X10-X16 from stack
   LDR X14, [SP, 48]                   // restore X10-X16 from stack
   LDR X16, [SP, 56]                   // restore X10-X16 from stack
   MOV X17, 0                          // set counter for loop of array
   B loop2                             // branch to loop for string of integer

loop2:
   LDRB W15, [X0,X17]                  // load in character from string of integers
   CBZ W15, befloop                    // if null terminator branch out of loop
   STRB W15, [X14,X12]                 // store character in outstring
   ADD X17, X17,1                      // increment counter of loop
   ADD X12, X12, 1                     // increment counter of outstring
   B loop2                             // branch to loop again 

befloop:
   ADD X10, X10, 2                     // add 2 to counter(to skip over %a in string as its 2 chars)
   ADD X11, X11, 2                     // add 2 to counter+1
   B loop                              // branch back to loop to conitnue looping through

exit: 
   MOV X1, X14                         // address of outstr to X1 for printing
   MOV X2, X12                         // get ready to print bringing length of string
   MOV X8, 64                          // setting destination to 64 for printing 
   MOV X0, 1                           // setting destination to 1 to print 
   SVC 0                               // invoke system call   
   MOV X0, X12                         // set return value to length of string
   LDR X30, [SP]                       // load X30 from frame
   ADD SP, SP, 120                     // de-allocate frame
   RET                                 // return

.data
    outstr:  .fill 1024, 1, 0
