/*
Author  : Amane Chibana
Pledge  : I pledge my honor that I have abided by the Stevens Honor System.
*/
.text
.global _start

_start:
    ADR X0, vec1 /*load vec1 address to register X0 */ 
    ADR X1, vec2 /*load vec2 address to register X1 */ 
    LDR X2, [X0] /*load 1st element of vec1 data into X2*/
    LDR X3, [X1] /*load 1st element of vec2 data into X3*/
    MUL X4, X2, X3 /*multiply vec1[0] and vec2[0] and store in X4*/
    LDR X2, [X0,8] /*load 2nd element of vec1 data into X2*/
    LDR X3, [X1,8] /*load 2nd element of vec2 data into X3*/
    MUL X5, X2, X3 /*multiply vec1[1] and vec2[1] and store in X5*/
    LDR X2, [X0,16] /*load 3rd element of vec1 data into X2*/
    LDR X3, [X1,16] /*load 3rd element of vec2 data into X3*/
    MUL X6, X2, X3 /*multiply vec1[2] and vec2[2] and store in X6*/
    ADD X4, X4, X5 /*add X4 and X5 and store in X4 */
    ADD X4, X4, X6 /*add X4 and X5 and store in X5 */
    ADR X1, dot /*load dot address to register X1 */
    STR X4, [X1] /*store X4 data in X1 - aka dot*/
    MOV X0, 0 /* status <- 0 */
    MOV X8, 93 /* exit() is system call #93 */
    SVC 0 /* invoke system call */

.data
    vec1: .quad 10, 20, 30
    vec2: .quad 1, 2, 3
    dot: .quad 0
    