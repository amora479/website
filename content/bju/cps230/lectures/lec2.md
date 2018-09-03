---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
hasMath: true
---

# Lecture 2: Number Systems

## Place / Value Number Systems

If we look at our standard, decimal number system, how do we know that `5` represents 5 1's and not 5 10's or 5 100's?  Its because the 5 is in the 1's place.  Our method of counting assigns each position in a number a value.  This same method carriers over to other number systems such as hexadecimal and binary, but it doesn't carry to number systems like roman numerals.

How do we know when we need to add a number to the next place value?  Is it not when we have hit the max in our current place value?

``` text
 0
 1
 2
 3
 4
 5
 6
 7
 8
 9
10 (max value hit, go back to zero but add 1 to next place value)
```

This works in binary as well.

``` text
   0
   1
  10
  11
 100
 101
 110
 111
1000
```

## Conversions

To determine what base a number is in, you need to look at its base (or subscript).  For example, {{< tex "100_2" >}} (in base 2) is equal to {{< tex "4_{10}" >}} (in base 10).

### Conversion to Base 10

Let's start with a binary number, {{< tex "10011001_2" >}}.  In binary, the place values are a bit different, we have 64, 32, 16, 8, 4, 2, 1 rather than 100s, 10s 1s etc. (or we have powers to 2 where each position is {base}^{pos})

``` text
 1  |  0  |  0  |  1  |  1  |  0  |  0  |  1
2^7 | 2^6 | 2^5 | 2^4 | 2^3 | 2^2 | 2^1 | 2^0 
```

To determine what decimal number this represents, we simply multiply each column and add the results:

``` text
 1  |  0  |  0  |  1  |  1  |  0  |  0  |  1
2^7 | 2^6 | 2^5 | 2^4 | 2^3 | 2^2 | 2^1 | 2^0 
----------------------------------------------
128 +  0  +  0  +  16 +  8  +  0  +  0  +  1   = 153
```

This same approach will work for any base, just update the {base}^{pos} row.  For example, base 9.

``` text
  1  |  4  |  5  |  1
 9^3 | 9^2 | 9^1 | 9^0 
----------------------
 729 + 324 +  45 +  9  = 1099
```

### Conversion from Base 10

If going to base 10 uses multiplication, it makes sense that from base 10 would use division.  Let's convert {{< tex "153_{10}" >}} back to binary.

We repeatedly divide by the base we're going to, keeping track of the remainders until our quotient hits 0.

``` text
153 / 2 = 76 r 1
 76 / 2 = 38 r 0
 38 / 2 = 19 r 0
 19 / 2 =  9 r 1
  9 / 2 =  4 r 1
  4 / 2 =  2 r 0
  2 / 2 =  1 r 0
  1 / 2 =  0 r 1
```

Then our answer is the remainders from bottom to top `10011001`.  This works for any base, let's check our work on {{< tex "1099_{10}" >}} by converting it back to base 9.

``` text
1099 / 9 = 122 r 1
 122 / 9 =  13 r 5
  13 / 9 =   1 r 4
   1 / 9 =   0 r 1
```

### Conversion from Any Base to Any Base

Based on the principles above, we can convert from any base to any other base by first converting to base 10 then to the needed base.  Let's do {{< tex "1221_{3}" >}} => {{< tex "?_{7}" >}} as an example.

``` text
  1  |  2  |  2  |  1
 3^3 | 3^2 | 3^1 | 3^0 
----------------------
  27 +  18 +  6  +  1  = 53
```

``` text
53 / 7 = 7 r 4
 7 / 7 = 1 r 0
 1 / 7 = 0 r 1
```

{{< tex "1221_{3}" >}} => {{< tex "104_{7}" >}}

### Special Cases

Binary <=> octal and binary <=> hexadecimal share a special relationship so there is a shortcut between these two sets.

To convert a binary number into hexadecimal, simply carve the binary number into groups of four (adding 0s to the front as necessary).  Then convert each group of four into a hexadecimal number.

``` text
    1  0010  0110  => 
(0001)(0010)(0110) =>
               126
```

To convert back, convert each hex digit into a group of 4 binary digits and append the binary group together.

For binary and octal, the group size is 3 instead of 4.