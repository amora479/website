---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Lecture 16: Variadic Functions

In C, there is sometimes a need to have parameters that support an unlimited number of parameters.  One of these special cases are the printf and scanf functions, and there are occasionally others.  Such functions are called variadic functions, and let's look at a simple example of how to write one.

First, include the stdargs library.  This imports several macros that allow us to access the varying number of parameters.  Second, the variadic function should have one required parameter.  Ideally, this parameter will contain the number of arguments provided by the user.  For printf and scanf, this count is embedded in the format string.  The remaining parameter(s) are represented by `...`.

``` c
#include "stdarg.h"
#include "stdio.h"

int sum(int count, ...) {

}

int main() {
	printf("%d\n", sum(3, 1, 2, 3));
	return 0;
}
```

Let's discuss the three macros.  First, we need a variable to represent the extra arguments (since they don't have a name and all).  This is done by declaring a `va_list` parameter.  We need to tell the va_list parameter where to start on the stack which is done by passing the va_list parameter as well as the parameter immediately preceeding the unlimited list to `va_start`.  Note that the va_list parameter has to be terminated before the function exits to prevent stack corruption using `va_end`.  Finally, the actual parameters can be obtained by iteratively calling `va_arg` with the va_list parameter as well as the expected type of the parameter.

Putting that all together to implement the sum function, we have.

``` c

int sum(int count, ...) {
	va_list args;
	va_start(args, count);

	int i, result = 0;
	for(i = 0; i < count; ++i) {
		result += va_arg(args, int);
	}

	va_end(args);
	return result;
}
```

And translated to 64-bit assembly, we would have...

```
default rel

extern printf

section .data

    fmt: db "%d", 10, 0

section .text

global sum
sum:
    ; put the registers into the shadow space so we can do stack walking
    mov     [rsp + 32], r9
    mov     [rsp + 24], r8
    mov     [rsp + 16], rdx
    mov     [rsp + 8], rcx
    push    rbp                     ; this requires more than a bit of stack access so frame pointer
    mov     rbp, rsp                ; create the new frame pointer
    mov     rax, 0                  ; rather than a local variable, we'll just use a register
.while:
    cmp     qword [rbp + 16], 0     ; we will decrement the first parameter and treat it as an index
    jge     .while_body
    jmp     .while_end
.while_body:
    mov     rcx, [rbp + 16]         ; get the current value of our index (the first parameter)
    lea     r10, [rbp + 16]         ; get the start of the arguments array
    add     rax, [r10 + rcx * 8]    ; add directly to rax from the stack
    dec     qword [rbp + 16]        ; decrement our counter (the first parameter)
    jmp     .while
.while_end:
    mov     rsp, rbp                ; return value already in rax so just get rid of the frame pointer
    pop     rbp                     ; restore the old frame pointer if there was one
    ret

global main
main:
    sub     rsp, 40                 ; we need a 5th parameter here, so just increase the size of the shadow space
    mov     qword [rsp + 32], 4     ; shove the 5th parameter into the shadow space the others into registers
    mov     r9, 3
    mov     r8, 2
    mov     rdx, 1
    mov     rcx, 4
    call    sum                     ; invoke sum
    
    mov     rdx, rax                ; standard printing
    lea     rcx, [fmt]
    call    printf
    
    add     rsp, 40                 ; remove the slightly larger than normal shadow space
    ret
```

## Simple scanf Implementation

In lab9, you'll be implementing variadic functions to write a simple version of printf.  For your reference and general amusement, I present a simple scanf with some random changes.  Note that we are going to stick with integers only (which we'll also do with printf) to keep things simple, and we'll support the following format specifiers.

| specifier | int type |
| --- | --- |
| %g | grok |
| %x | hex |
| %d | decimal |
| %b | binary |

``` c
#include "stdarg.h"
#include "string.h"
#include "stdio.h"

// readUntilNotInRange
// params:
//      - c - the character starting the string
//      - min1 - which part of the range from 0 to 9 is desired
//      - max1 - which part of the range from 0 to 9 is desired
//      - base1 - what is the base value of the min1 - max1 range
//      - min@ - which part of the range from A to Z is desired
//      - max2 - which part of the range from A to Z is desired
//      - base2 - what is the base value of the min2 - max2 range
//      - multiplier - what is the number's base
int readUntilNotInRange(char c, char min1, char max1, int base1, char min2, char max2, int base2, int multiplier) {
    int result = 0, negative = 0, no_more_negatives = 0;
    while((c >= min1 && c <= max1) || (c >= min2 && c <= max2) || (!no_more_negatives && c == '-')) { // we are in range
        if(c != '-') {
            no_more_negatives = 1; // do not allow any more negative signs because we have our first digit
            if((c >= min1 && c <= max1)) { // figure out the range
                result *= multiplier; // multiply by the base
                result += (c - min1) + base1; // do a bit of math to figure out the digit's decimal representation
            } else if((c >= min2 && c <= max2)) {
                result *= multiplier;
                result += (c - min2) + base2;
            }
        } else {
            negative = !negative; // flip the sign of the number
        }
        c = getchar();
    }
    return result * (negative ? -1 : 1);
}

int readAsGrok(char c) {
    return readUntilNotInRange(c, '0', '9', 0, 'A', 'I', 10, 19);
}

int readAsHex(char c) {
    return readUntilNotInRange(c, '0', '9', 0, 'A', 'F', 10, 16);
}

int readAsDecimal(char c) {
    return readUntilNotInRange(c, '0', '9', 0, '0', '9', 0, 10);
}

int readAsBinary(char c) {
    return readUntilNotInRange(c, '0', '1', 0, '0', '1', 0, 2);
}

// scanf
// params:
//      - fmtString - a format string
//                  - only %g (grok), %d (decimal) and %b (binary) are supported
//      - ... - a list of addresses to read into
// returns: the number of items we read successfully
int myScanf(char *fmtString, ...) {
    va_list args; // declare a variable argument list
    va_start(args, fmtString); // tell the variable argument list where to start
                               // this is almost always the last named parameter

    char c = getchar(); //read one character from the user to start
    int lenOfFmtString = strlen(fmtString), itemsRead = 0;
    for(int i = 0; i < lenOfFmtString; ++i) {
        if(fmtString[i] == '%' && i + 1 < lenOfFmtString) { // did we get a percent symbol
            ++i;
            switch(fmtString[i]) { // yes, check the format specifier
                case 'g':
                case 'G':
                    *va_arg(args, int*) = readAsGrok(c);
                    ++itemsRead;
                    break;
                case 'x':
                case 'X':
                    *va_arg(args, int*) = readAsHex(c);
                    ++itemsRead;
                    break;
                case 'd':
                case 'D':
                    *va_arg(args, int*) = readAsDecimal(c);
                    ++itemsRead;
                    break;
                case 'b':
                case 'B':
                    *va_arg(args, int*) = readAsBinary(c);
                    ++itemsRead;
                    break;
                case '%':
                    if(c != '%') {
                        printf("expected a %% but read a %c\n", c);
                        return -1;
                    }
                    break;
                default:
                    printf("%c is not a recognized format specifier.\n", fmtString[i]);
                    break;
            }
        } else {
            if(c != fmtString[i]) { // the character we read didn't match what scanf said it should be
                printf("expected a %c but read a %c\n", fmtString[i], c);
                return -1;
            } else {
                c = getchar(); //read a character from the user
            }
        }
    }
    va_end(args); // end the variable argument list (cleanup)
    return itemsRead;
}

int main() {
    int num;
    myScanf("%g", &num);
    printf("%d", num);
}
```
