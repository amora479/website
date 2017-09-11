---
title: "CPS 230 Lecture 5"
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