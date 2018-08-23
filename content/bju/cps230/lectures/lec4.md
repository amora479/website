---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 4: Bit Manipulation

Being able to manipulate bits is a fundamental task of both C and Assembly programmers.  Working with numbers and data at the binary level allows us to be efficient, but it also allows us to answer properties about the number such as whether its 7th position is set.  

Let's look at a few operators, then we'll do some work with the operators.

## NOT

Not works with a single number, and flips every bit in the number.

``` text
! | 0 | 1
---------
  | 1 | 0
```

So if we have the binary number 10010011, it would be come 01101100 after not is applied.

## OR

Or works with two numbers, and sets the result bit to true if either bit is true

``` text
  | 0 | 1
---------
0 | 0 | 1
---------
1 | 1 | 1
```

So if we were to take the numbers 1001 and 1100 then combine them with or, we would have 1101.

## AND

And works with two numbers, and sets the result bit to true if both bits are true

``` text
  | 0 | 1
---------
0 | 0 | 0
---------
1 | 0 | 1
```

So if we were to take the numbers 1001 and 1100 then combine them with and, we would have 1000.

## XOR

And works with two numbers, and sets the result bit to true if both bits do not match

``` text
  | 0 | 1
---------
0 | 0 | 1
---------
1 | 1 | 0
```

So if we were to take the numbers 1001 and 1100 then combine them with xor, we would have 0101

## SHL

Shl (or shift lift) works with a single number, but it does take an operand (how much to shift).

Shift left moves all binary digits to the left replacing the evacuated space with the requested number of 0s.

So if we took the number 10010011 and executed Shl on it with a parameter of 3, we would get 10011000.

## SHR

Shr (or shift right) works with a single number, but it does take an operand (how much to shift).

Shift right moves all binary digits to the right replacing the evacuated space with the requested number of 0s.  **WARNING: For now, we are going to assume that we get 0s, but in reality, this is not guaranteed.  We'll see why when we get to assembly.**

So if we took the number 10010011 and executed Shr on it with a parameter of 3, we would get 00010010.

## Read Big Endian, Print Little Endian

This small program reads a two digit hexadecimal number in big endian, and it then prints that number out in little endian.

```c
#include "stdio.h"

int main(int argc, char** argv) {
	int bigEndianNumber;
	scanf("%x", &bigEndianNumber);
	int littleEndianNumberHighByte = ((bigEndianNumber << 4) & 0b11110000);
	int littleEndianNumberLowByte = ((bigEndianNumber >> 4) & 0b00001111);
	printf("%x\n", bigEndianNumber);
	printf("%x\n", littleEndianNumberHighByte);
	printf("%x\n", littleEndianNumberLowByte);
	printf("%x\n", littleEndianNumberHighByte + littleEndianNumberLowByte);
	return 0;
}
```

## Is a Bit Set?

This program reads a number then a bit position.  It prints yes, if that bit position is 1 and no otherwise.

```c
#include "stdio.h"

int main(int argc, char** argv) {
	int number, position;
	scanf("%d", &number);
	scanf("%d", &position);
	number = (number >> (position - 1));
	number = number & 0b1;
	if(number) {
		printf("%s\n", "yes");
	} else {
		printf("%s\n", "no");
	}
	return 0;
}
```