.text
.global _start
.extern printf


/* char _uppercase(char lower) */
_uppercase:

    SUB SP, SP, 8         // allocate frame

    SUB W0, W0, 32        // convert to lowercase

    ADD SP, SP, 8         // de-allocate frame 
    RET

/* int _toupper(char* string) */
_toupper:

    SUB SP, SP, 24        // allocate frame
    STR X30, [SP]         // store X30 in the frame

    MOV X9, X0            // set X9 to X0 
    MOV X10, 0            // set X10 to 0 
    MOV X11, 0            // set X11 to 0 
    

loop:

    LDRB W0, [X9,X11]     // load X11th byte from X9
    CBZ W0, exit          // if W0 is equal to 0, branch to exit
    CMP W0, 'a'           // compare W0 to char a
    B.LT skip             // if W0 is less than 'a' branch to skip
    CMP W0, 'z'           // compare W0 to char z
    B.GT skip             // is W0 is greater than char z branch to skip
    BL _uppercase         // call uppercase()
    ADD X10, X10, 1       // increment X10 by 1 

skip:

    STRB W0, [X9,X11]     // store byte W0 in X11th byte of X9 
    ADD X11, X11, 1       // increment X11 by 1 
    B loop                // branch to loop

exit: 

    MOV X0, X10           // set X0 to X10 

    LDR X30,[SP]          // restore X30 back
    ADD SP, SP, 24        // de-allocate frame 

    RET

_start:

    ADR X0, str            // load address of str to X0 (arg)
    BL _toupper            // call toupper()
    
    MOV X1, X0             // move X0 data to X1
    ADR X2, str            // load address of str in X2
    ADR X0, outstr         // load address of outstr in X0

    BL printf              // call printf()

    MOV  X0, 0             // status <- 0 
    MOV  X8, 93            // exit() is system call #93
    SVC  0                 // invoke system call


.data
str:    .string   "helloworld"
outstr: .string   "Converted %ld characters: %s\n"
