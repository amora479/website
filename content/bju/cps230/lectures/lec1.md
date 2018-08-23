---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 1: C Introduction
## Hello World

Like all good language introductions, let's start with "hello world" and then unpack it!

```
#include "stdio.h"

int main(int argc, char** argv) {
	printf("%s\n", "hello world");
	return 0;
}
```

In order to unpack this simple program, we need to know a little more about how the C processor works.  The compiler is split into 4 phases.

![img](/course/bju/content/cps230/images/lec_1_img_1.png)

* Proprocessor - This phase find preprocessor statements and transforms the program based on the statement. These statements always begin a `#` and there are quite a few of them.  For our purposes, we're only going to consider `#include` which is how libraries are referenced.  In this case, `#include "stdio.h"` means include C's standard I/O library.  Note, only references to functions are included, not the actualy functions themselves (this comes later).
* Compiler - This phase converts the transformed program into assembly.
* Assembler - This phase converts the assembly into an object file.
* Linker - This is where referenced functions actually get included.  Generally speaking, another object file containing the functions referenced is inserted into the object file(s) containing your code.

Now that we know a bit about the C compiler, let's unpack the various lines of the program above.

```
#include "stdio.h"
```

This first line, as we said, is a preprocessor directive telling the compiler to include references to C's standard I/O library and its functions.  In this course, there are two functions in the library that we care very much about: `printf` and `scanf`.  These functions are how we'll handle input and output.

```
int main(int argc, char** argv) {
	
}
```

This is a function declaration, and `argc` and `argv` are parameters.  Don't worry too much about the `**` notation at the moment.  It actually has a complex meaning that we'll get into later.  

Note that every C program must have 1 and only 1 function named `main`.  This will be the "entry point" that the compiler uses to start your program.  In other words, this is the function that gets executed first.  No main function, program no run!

```
printf("%s\n", "hello world");
```

The `printf` function is actually deceptively powerful as is `scanf`.  The first parameter of both is what is known as a format string.  This string allows you to perform complex formatting tasks.  Need to left pad a number with up to 5 0's? Easy. Want to print an interger in binary or hexadecimal?  No problem.  The remaining parameters are inserted (in order) into the format string at the marked locations (`%`).  In this case, `%s` means copy the contents of a string here.  Formatting parameters typically go between the `%` and the type `s`.

```
return 0;
```

Your main function should always return a value.  This is how the operating system knows whether the program ran successfully, or if it failed or threw an exception.  A 0 means everything is fine.  Any other value means something bad happened.  Think of it like this.  At the end of execution, the OS asks "did you die?"  The program responds with false (0) or true (!0);

## Basic C

### Comments

```c

// C has two kinds of comments, this is a single line comment

/* and
 here
 is a
 multiline
 one */

```

### Variables

```c
int x; // this is how you declare an integer variable 
int y = 3; // this is a variable with a pre-defined value;
int z = 4, aa; //two variables, one pre-defined and one not
```

### Types

```c
// number types

char a; // number with a value of -128 to 127
unsigned char b; // number with a value of 0 to 255
int c; // number with a value of -2,147,483,648 to 2,147,483,647
unsigned int d; // number with a value of 0 to 4,294,967,295
short e; // number with a value of -32,768 to 32,767
unsigned short f; // number with a value of 0 to 65,535

// float types

float g; // about 6 decimal places
double h; // about 15 decimal places
long double i; // about 19 decimal places

// array / string types

char* j; // an array of chars (or a string)
char k[]; // same as k, just different notation
char l[10]; // same as j and k, but with a size of 10

```

### Control Structures

Note: C does not have booleans! or at least dedicated booleans.  In C, 0 is false and everything else is true.

Note: In earlier versions of C, for loops did not allow you to both declare an initialize a variable.  You had to separate them as is shown below.  Modern C compilers will let you declare and initialize `i` in the for loop.  However, it is a good idea to be aware of this facet of the language's history in case you ever need to use an older C compiler.

```c
if(1) {
	printf("%s", "i'm true");
} else if (2) {
	printf("%s", "i'm also true");
} else {
	printf("%s", "i might be true");
}

while(1) {
	printf("%s", "hey look an infinite loop");	
}

int i;
for(i = 0; i < 20; ++i) {
	printf("%s", "i'll be printed 20 times");	
}
```

### Math Operators

```c
a + b; // add a and b
a − b; // subtract b from a
a * b; // multiply a and b
a / b; // divide a by b
a % b; // divide a by b and return the remainder
a++; // increment a by 1
++a; // increment a by 1
a--; // decrement a by 1
--a; // decrement a by 1

a == b; // return true if a and b are equal
a != b; // return true if a and b are not equal
a > b; // return true if a is greater than b
a < b; // return true if a is less than b
a >= b; // return true if a is greater than or equal to b
a <= b; // return true if a is less than or equal to b
a && b; // return true if a and b are equal
a || b; // return true if a or b is equal
!a; // if a is true, return false, else return true

a & b; // bitwise and of a and b
a | b; // bitwise or of a and b
a ^ b; // bitwise xor of a and b
~a; // flip the bits of a
a << b; // left shift the bits of a b times
a >> b; // right shift the bits of a b times

a = b; // set a equal to b
a += b; // add a and b and put the result in a
a -= b; // subtract b from a and put the result in a
a *= b; // multiply a and b and put the result in a
a /= b; // divide a by b and put the result in a
a %= b; // divide a by b and put the remainder in a
a <<= b; // left shift a b times and put the result in a
a >>= b; // right shift a b times and put the result in a
a &= b; // bitwise and of a and b with result in a
a ^= b; // bitwise or of a and b with result in a
a |= b; // bitwise xor of a and b with result in a
```

### Printing

Each formatter in the format string follows this pattern where the parts in `[]` braces are optional: `%[flags][width][.precision]specifier`.

#### Specifiers

| Specifier | Output |
| --- | --- |
| d or i | Signed Decimal Integer |
| u | Unsigned Decimal Integer |
| o | Unsigned Octal |
| x | Unsigned Hexadecimal Integer |
| X | Unsigned Hexadecimal Integer (Uppercase) |
| f | Decimal Floating Point |
| e | Scientific Notation (Mantissa/Exponent), Lowercase |
| E | Scientific notation (Mantissa/Exponent), Uppercase |
| g | Use the Shortest Representation: `%e` or `%f` |
| G | Use the Shortest Fepresentation: `%E` or `%F` |
| a | Hexadecimal Floating point, Lowercase |
| A | Hexadecimal Floating point, Uppercase |
| c | Character |
| s | String |
| % | % |

#### Flags

| Flags | Description |
| --- | --- |
| -	| Left-justify within the given field width; Right justification is the default (see width sub-specifier). |
| +	| Forces to preceed the result with a plus or minus sign (+ or -) even for positive numbers. By default, only negative numbers are preceded with a - sign. |
| (space) | If no sign is going to be written, a blank space is inserted before the value. |
| # | Used with o, x or X specifiers the value is preceeded with 0, 0x or 0X respectively for values different than zero. Used with a, A, e, E, f, F, g or G it forces the written output to contain a decimal point even if no more digits follow. By default, if no digits follow, no decimal point is written. |
| 0 | Left-pads the number with zeroes (0) instead of spaces when padding is specified (see width sub-specifier). |

#### Width

| Width | Description |
| --- | --- |
| (number) | Minimum number of characters to be printed. If the value to be printed is shorter than this number, the result is padded with blank spaces. The value is not truncated even if the result is larger. |
| * | The width is not specified in the format string, but as an additional integer value argument preceding the argument that has to be formatted. |

#### .Precision

| Precision | Description |
| --- | --- |
| .number | For integer specifiers (d, i, o, u, x, X): precision specifies the minimum number of digits to be written. If the value to be written is shorter than this number, the result is padded with leading zeros. The value is not truncated even if the result is longer. A precision of 0 means that no character is written for the value 0. For a, A, e, E, f and F specifiers: this is the number of digits to be printed after the decimal point (by default, this is 6). For g and G specifiers: This is the maximum number of significant digits to be printed. For s: this is the maximum number of characters to be printed. By default all characters are printed until the ending null character is encountered. If the period is specified without an explicit value for precision, 0 is assumed. |
| .* | The precision is not specified in the format string, but as an additional integer value argument preceding the argument that has to be formatted. |

```c
printf("Characters: %c %c \n", 'a', 65); // prints "Characters: a A"
printf("Decimals: %d %ld\n", 1977, 650000L); // prints "Decimals: 1977 650000"
printf("Preceding with blanks: %10d \n", 1977); // prints "Preceding with blanks:       1977"
printf("Preceding with zeros: %010d \n", 1977); // prints "Preceding with zeros: 0000001977"
printf("Some different radices: %d %x %o %#x %#o \n", 100, 100, 100, 100, 100); // prints "Some different radices: 100 64 144 0x64 0144"
printf("floats: %4.2f %+.0e %E \n", 3.1416, 3.1416, 3.1416); // prints "floats: 3.14 +3e+000 3.141600E+000"
printf("Width trick: %*d \n", 5, 10); // prints "Width trick:    10"
printf("%s \n", "A string"); // prints "A string"
```

### Reading

Note: We won't go into much detail now, but always put a `&` in front of the variable you are reading into.

Each formatter in the format string follows this pattern where the parts in `[]` braces are optional: `%[width]specifier`;

#### Specifiers

| Specifier | Description |
| --- | --- |
| i | Any number of digits, optionally preceded by a sign (+ or -). Decimal digits assumed by default (0-9), but a 0 prefix introduces octal digits (0-7), and 0x hexadecimal digits (0-f). |
| d | or u Any number of decimal digits (0-9), optionally preceded by a sign (+ or -). |
| o | Any number of octal digits (0-7), optionally preceded by a sign (+ or -). |
| x | Any number of hexadecimal digits (0-9, a-f, A-F), optionally preceded by 0x or 0X, and all optionally preceded by a sign (+ or -). |
| f, e, g | Floating Point Number. A series of decimal digits, optionally containing a decimal point, optionally preceeded by a sign (+ or -) and optionally followed by the e or E character and a decimal 
| c | The next character. If a width other than 1 is specified, the function reads exactly width characters and stores them in the successive locations of the array passed as argument. No null character is appended at the end. |
| s | Any number of non-whitespace characters, stopping at the first whitespace character found. A terminating null character is automatically added at the end of the stored sequence. |
| % | % |

#### Subspecifiers

| Subspecifier | Description |
| --- | --- |
| width | Specifies the maximum number of characters to be read in the current reading operation (optional). |

```c
char str [80];
int i;

printf("Enter your family name: ");
scanf("%79s",str);  
printf("Enter your age: ");
scanf("%d",&i);
printf("Mr. %s , %d years old.\n",str,i);
printf("Enter a hexadecimal number: ");
scanf("%x",&i);
printf("You have entered %#x (%d).\n",i,i);

// This will print
/*
Enter your family name: Soulie
Enter your age: 29
Mr. Soulie , 29 years old.
Enter a hexadecimal number: ff
You have entered 0xff (255).
*/
```