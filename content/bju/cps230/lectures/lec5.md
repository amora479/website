---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 5: Two's Complement
## Set / Clear Individual Bits & Printing Binary

``` c
#include "stdio.h"

short clear_a_bit(short x, short position) {
	int mask = (1 << position);
	return x & ~mask;
}

short set_a_bit(short x, short position) {
	int mask = (1 << position);
	return x | mask;
}

void print_binary(short x) {
	char binary[] = "0000000000000000";
	int pos = 15;
	printf("%d %d\n", x / 2, x % 2);
	while (x != 0) {
		binary[pos] = ((x % 2) ? '1' : '0');
		x /= 2;
		printf("%d %d\n", x / 2, x % 2);
		--pos;
	}
	printf("%s\n", binary);
}

int main() {
	short x = 0b0101010101010101;
	print_binary(set_a_bit(x, 3));
	scanf("%d", x);
	return 0;
}
```

## Binary Addition

There are four possibilities when adding two bits

```text
0 + 0 = 0
1 + 0 = 1
0 + 1 = 1
1 + 1 = 10
```

Note: with the last example (when the number of bits in the answer is greater than the number of bits in the operands), the extra bits are known as a carry.

Let's do a simple example.

```text
  1111
  11001100
+ 10111011
----------
 110000111 
```

## Two's Complement

So far, we have only looked at unsigned binary numbers.  Now, we need to discuss how signed numbers are represented.  In binary, we can't stick a negative sign in front of the number to represent the fact that it is binary (or can we).  A very common method of representing binarys (in almost every computer architecture) is known as two's complement.  The most signifigant bit of a binary number is reserved as the sole negative big.  So for an 8-bit number, we have (-2^7 2^6 2^5 2^4 2^3 2^2 2^1 2^0) for our positions.

Converting a negative decimal to two's complement is rather easy.  First convert the mantissa to binary, then flip the bits.  Finally add one and you are done.  Let's do a quick example with -78.

``` text
mantissa:      01001100
flip the bits: 10110011
add 1:         10110100
```

We can check our work by convert back to decimal (keeping in mind the MSB is actuall -2^7).

``` text
-128 + 64 + 8 + 4 = -78
```

Note that to convert from two's complement back to non's two's complement, the process is the same.  Take a two's complement number, flip the bits and add 1.  We can confirm this with our last example.

``` text
2s complement: 10110100
flip the bits: 01001011
add 1:         01001100 (the same as our original number)
```

In two's complement, binary addition / subtraction are the same operation.  Just make sure to two's complement the second operand for subtraction!

## Overflow / Carry

Overflow is when your operands have the same MSB but the result has a different MSB, and a carry is when the number of bits in the result is greater than the operand with the most bits.

``` text
  0011
+ 1100
------
  1111 (no overflow, no carry)

  0111
+ 0001
------
  1000 (overflow, no carry)

  1111
+ 0001
------
 10000 (no overflow, carry)
```

## Multiplication

Multiplication in binary is a bit "different" because we take into account that our result can be much larger than our operands.  If you multiply two 4 digit binary numbers, the result has 8 digits.  If you multiply two 16, the result has 32.  Whatever you multiply, the result has double the bits.

This can lead to some weird problems (like wrong answers!).

``` text
    1100 (-8)
  x 0011 (3)
  ------
    1100
   1100
  ------
  100100 (36)
```

For this reason, we have to sign extend our operands to match the size of our result.  Sign extend means just simply copying the MSB of the operands over to fill in the extra bits.

``` text
    11111100 (-8)
  x 00000011 (3)
  ----------
    11111100
   11111100
  ----------
  1011110100 (we only can keep 8 bits so 11110100 is our answer, or -24)
```

## Division

Division in binary is much like multiplication, except the dividend is the number that has to be bigger (twice as big as the divisor to be precise), and we can use sign extension to accomplish that if necessary.  We shift 1 bit of the divident each time and compare it to the divisor.  If the divisor is greater, we shift a 0 onto the quotient.  If the divident is greater, we shift a 1 onto the quotient and subtract the divisor from the divident.

``` text

     ----------
1000 | 01001010

(is 1000 less than 0? no, shift a 0)

       0
     ----------
1000 | 01001010

(is 1000 less than 01? no, shift a 0)

       00
     ----------
1000 | 01001010

(is 1000 less than 010? no, shift a 0)

       000
     ----------
1000 | 01001010

(is 1000 less than 0100? no, shift a 0)

       0000
     ----------
1000 | 01001010

(is 1000 less than 01001? yes, shift a 1 and subtract)

       00001
     ----------
1000 | 01001010
        1000
       -----
           10

(is 1000 less than 10? no, shift a 0)

       000010
     ----------
1000 | 01001010
        1000
       -----
           101

(is 1000 less than 101? no, shift a 0)

       0000100
     ----------
1000 | 01001010
        1000
       -----
           1010

(is 1000 less than 1010? yes, shift a 1 and subtract)

       00001001
     ----------
1000 | 01001010
        1000
       -----
           1010
           1000
           ----
             10 (remainder)
```