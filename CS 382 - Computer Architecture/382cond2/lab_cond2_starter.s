/*
Author  : Amane Chibana
Pledge  : I pledge my honor that I have abided by the Stevens Honor System.
*/
.text
.global _start
.extern scanf

_start:
    
    ADR   X0, fmt_str   // Load address of formated string
    ADR   X1, left      // Load &left
    ADR   X2, right     // Load &right
    ADR   X3, target    // Load &target
    BL    scanf         // scanf("%ld %ld %ld", &left, &right, &target);

    ADR   X1, left      // Load &left
    LDR   X1, [X1]      // Store left in X1
    ADR   X2, right     // Load &right
    LDR   X2, [X2]      // Store right in X2
    ADR   X3, target    // Load &target
    LDR   X3, [X3]      // Store target in X3

    CMP X3,X1           // Compare X3 and X1
    B.LE out            // jump to out if X3 is less than or equal to to X1 

    CMP X2,X3           // Compare X2 and X3
    B.LE out            // jump to out if X2 is less than or equal to X3 

    ADR X1, yes         // load address to register X1 
    ADR X0, len_yes     // load address to register X0 
    LDR X2, [X0]        // load data into X2
    MOV X8, 64          // setting destination to 64 for printing 
    MOV X0, 1           // setting destination to 1 to print 
    SVC 0               // invoke system call 
    B exit              // jump to exit call 


out:
    ADR X1, no          // load address to register X1 
    ADR X0, len_no      // load address to register X0 
    LDR X2, [X0]        // load data into X2
    MOV X8, 64          // setting destination to 64 for printing 
    MOV X0, 1           // setting destination to 1 to print 
    SVC 0               // invoke system call 



exit:
    MOV   X0, 0        // Pass 0 to exit()
    MOV   X8, 93       // Move syscall number 93 (exit) to X8
    SVC   0            // Invoke syscall

.data
    left:    .quad     0
    right:   .quad     0
    target:  .quad     0
    fmt_str: .string   "%ld%ld%ld"
    yes:     .string   "Target is in range\n"
    len_yes: .quad     . - yes  // Calculate the length of string yes
    no:      .string   "Target is not in range\n"
    len_no:  .quad     . - no   // Calculate the length of string no
