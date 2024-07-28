/*  
   Name: Amane Chibana 
   Pledge: I pledge my honor that I have abided by the Stevens Honor System.
 */

.global count_specs

count_specs:
   SUB SP, SP, 8               // allocate frame
   MOV X8, 0                   // set X8 to 0 for counter through string
   MOV X10, 0                  // set X10 for counter for number of %a's
   MOV X11, 1                  // set X11 to 1 for counter+1 through string 

readstr:
   LDRB W9, [X0,X8]            // load in byte of string 
   CBZ W9, exit                // if byte is null terminator branch to exit
   CMP W9, '%'                 // check if byte is beginning of specifier
   B.EQ specifiercheck         // if they are equal branch to add to check for correct specifier 
   ADD X8, X8, 1               // add 1 to counter
   ADD X11, X11, 1             // add 1 to counter+1
   B readstr                   // branch to readstr loop

specifiercheck:
   LDRB W12, [X0,X11]          // load the byte after X8th byte
   CMP W12, 'a'                // check if it is equal to a
   ADD X8, X8, 1               // add 1 to counter
   ADD X11, X11, 1             // add 1 to counter+1
   B.NE readstr                // if they are not equal branch to readstr without adding to X10 counter
   ADD X10, X10, 1             // add 1 to counter for number of specifiers
   B readstr                   // branch to read string 

exit:
   MOV X0, X10                 // move data of X10 to X0 for output
   ADD SP, SP, 8               // de-allocate frame
   RET                         // return      
