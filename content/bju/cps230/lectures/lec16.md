---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 16: Variodic Functions

In C, there is sometimes a need to have parameters that support an unlimited number of parameters.  One of these special cases are the printf and scanf functions, and there are occasionally others.  Such functions are called variadic functions, and let's look at a simple example of how to write one.

First, include the stdargs library.  This imports several macros that allow us to access the varying number of parameters.  Second, the variodic function should have one required parameter.  Ideally, this parameter will contain the number of arguments provided by the user.  For printf and scanf, this count is embedded in the format string.  The remaining parameter(s) are represented by `...`.

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

## Simple scanf Implementation

In lab9, you'll be implementing variadic functions to write a simple version of printf.  For your reference and general amusement, I present a simple scanf with some random changes.  Note that we are going to stick with integers only (which we'll also do with printf) to keep things simple, and we'll support the following format specifiers.

| specifier | int type |
| --- | --- |
| %d | decimal |
| %u | unsigned decimal |
| %g | hex |
| %c | octal |
| %3 | ternary |

``` c
#include "stdarg.h"
#include "stdio.h"
 
char c;
 
int readDecimal(int allowNegatives) {
    int decimal = 0, negative = 0;
    while((c >= '0' && c <= '9') || c == '-') {
        if(c != '-') {
            decimal *= 10;
            decimal += (c - '0');
        } else {
            if(allowNegatives) {
                negative = !negative;
            } else {
                printf("Please enter an unsigned number\n");
            }
        }
        c = getchar();
    }
    return decimal * (negative ? -1 : 1);
}
 
int readOctal() {
    int octal = 0, negative = 0;
    while((c >= '0' && c <= '7') || c == '-') {
        if(c != '-') {
            octal *= 8;
            octal += (c - '0');
        } else {
            negative = !negative;
        }
        c = getchar();
    }
    return octal;
}

int readTernary() {
    int octal = 0, negative = 0;
    while((c >= '0' && c <= '2') || c == '-') {
        if(c != '-') {
            octal *= 3;
            octal += (c - '0');
        } else {
            negative = !negative;
        }
        c = getchar();
    }
    return octal;
}
 
int readHex() {
    int hex = 0, negative = 0;
    while((c >= '0' && c <= '9') || (c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f') || c == '-') {
        if(c != '-') {
            hex *= 16;
            if(c >= '0' && c <= '9') {
                hex += (c - '0');
            } else if(c >= 'A' || c <= 'F') {
                hex += (c - 'A') + 10;
            } else if(c >= 'a' || c <= 'f') {
                hex += (c - 'a') + 10;
            }
        } else {
            negative = !negative;
        }
        c = getchar();
    }
    return hex;
}
 
void myScanf(char* fmtString, ...) {
    va_list args;
    va_start(args, fmtString);
 
    c = getchar();
    //%d - decimal
    //%u - unsigned decimal
    //%g - hex
    //%c - octal
    //%3 - ternary
    int i = 0;
    for(i = 0; fmtString[i] != 0; ++i) {
        if(fmtString[i] == '%') {
            ++i;
            switch(fmtString[i]) {
                case 'd':
                case 'D':
                    int *ptr1 = va_arg(args, int*);
                    *ptr1 = readDecimal(1);
                    break;
                case 'u':
                case 'U':
                    int *ptr2 = va_arg(args, int*);
                    *ptr2 = readDecimal(0);
                    break;
                case 'c':
                case 'C':
                    int *ptr3 = va_arg(args, int*);
                    *ptr3 = readOctal();
                    break;
                case '3':
                    int *ptr4 = va_arg(args, int*);
                    *ptr4 = readTernary();
                    break;
                case 'g':
                case 'G':
                    int *ptr5 = va_arg(args, int*);
                    *ptr5 = readHex();
                    break;
                default:
                    printf("invalid input\n");
                    return;
            }
        } else {
            if(c != fmtString[i]) {
                printf("please enter a %c\n", fmtString[i]);
                return;
            } else {
                c = getchar();
            }
        }
    }
 
    va_end(args);
}
 
int main() {
    int hexVar;
    int udecVar;
    int decVar;
    int octVar;
    int terVar;
    myScanf("%g %u %d %c %3", &hexVar, &udecVar, &decVar, &octVar, &terVar);
    printf("%d\n", hexVar);
    printf("%d\n", udecVar);
    printf("%d\n", decVar);
    printf("%d\n", octVar);
    printf("%d\n", terVar);
    return 0;
}
```
