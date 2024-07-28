/*******************************************************************************
 * Filename: demo2.s
 * Author  : Amane Chibana
 * Version : 1.0
 * Date    : September 19, 2023
 * Description: Simple assembly program to display Hello World
 * Pledge  : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/
.text
.global _start

_start:
    ADR X1, msg /*load address to register X1 */ 
    ADR X0, num /*load address to register X0 */
    LDR X2, [X0] /*load data into X2*/
    MOV X8, 64 /*setting destination to 64 for printing */
    MOV X0, 1 /*setting destination to 1 to print */
    SVC 0 /*invoke system call */
    MOV X0, 0 /* status <- 0 */
    MOV X8, 93 /* exit() is system call #93 */
    SVC 0 /* invoke system call */

.data
    msg: .string "Hello World!\n" 
    num: .quad 13



    