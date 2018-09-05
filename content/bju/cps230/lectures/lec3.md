---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Lecture 3: Words (and Words)

## Bits, Bytes and Words

Computers have to work with fixed-size binary numbers.  This helps us know where things start and where things end, and otherwise prevents chaos.  

Bits obviously are the smallest fixed-size, just 1.  The smallest addressable size is a byte (which is 8 bits).  Words (or "native sizes") are the size of an address for an architecture, and the choice of word size for an architecture is important.  It is typically the amount of data that a processor can handle in one go. If you're reading through Intel documentation, "word" refers to 16 bit groups (the original size for the 8086).  A dword refers to 32 bits.

So if we have a byte, the range is 0 to 255.  And since it's a single byte, no need to worry about order.  If we have 2 bytes, we can store from 0 to 65535.  But what order should we put the bytes in?  With 4 bytes (32 bits), things get even worse.  What order should put the bytes in?

### Endianess

When it comes to storing words, on disk, there are two competing schools of thought:  the most signifigant bits (MSBs) should be stored first and the least signifigant bits (LSBs) should be stored first.

Most / Least Signifigant Bit?
``` text
149 = 10000101
      ^      ^
      MSB    LSB
```

The MSB is the bit referencing the highest value in a binary number.  To display big-endian (MSBs first) and little-endian (LSBs first), let's use a slightly bigger number in hex `0x12345678`

With big-endian, the layout in memory (keeping in mind that memory is addressed in bytes) would be:

| 0x00000000 | 0x00000001 | 0x00000002 | 0x00000003 |
| --- | --- | --- | --- |
| 12 | 34 | 56 | 78 |

while little-endian would be:

| 0x00000000 | 0x00000001 | 0x00000002 | 0x00000003 |
| --- | --- | --- | --- |
| 78 | 56 | 34 | 12 |

You might protest that little-endian is backwards (and it is from a human perspective).  So why would anyone want to use it?  One compelling reason is addition and subtraction (which are done from LSB to MSB).  In big-endian, you have to address to the end of the number then read backwards, but with little-endian, just read forward, doing the operation as you go.

The choice of which to use really depends on the computer architecture (and if you think the emacs / vim arguments are heated, you ain't seen nothing yet).  Suffice it to say, the endianess of a number is important, particularly if you are sending data between computers that use different layouts!

## Encodings

So if you think the arguments about integer layouts are bad, let's talk about strings. Back in the olden days, everything on a computer was in English, so the only encoding needed was one that handled english.  Enter ASCII...

### ASCII

ASCII is a simple encoding that has 128 characters (7 bits worth!), and each character had an assigned numerical value.  This encompasses control characters (things like line feed, carriage return), common symbols, numbers, upper case letters and lower case letters.  The problem is this set of 127 characters included no international characters.  Some very intelligent people realized this and also realized that since we store things in bytes, there was a full 128 possible ASCII values that weren't being used.  Unfortunately, a bunch of people realized this, and essentially, an "extended ASCII" was created for each language.  The original 128 characters stayed the same, but the next 128 varied wildly based on which ASCII you were using.

Imagine tranmitting data from computer to another (with both computers have different ASCII versions).

### UTF-8

As you can imagine, the ASCII mess became a headache for almost everyone, so it was decided that a more portable format was needed. This format was to be named unicode (or formally UTF [Unicode Transformation Format]). First, the 8 in UTF-8 represents the block size in bits, not the number of bytes or bits used to store a number.  Second, unicode doesn't map characters to integers, rather it maps them to code points, which look like this U+10FFFF.  Officially unicode runs from U+000000 to U+10FFFF (having approximately 1,114,111 possible characters).  How these values are represented in binary on disk is left up to the encoding.

The initial suggestion was to just store everything in 3 byte blocks, but this made a lot of people unhappy since it would make english (ASCII) strings take 3x the amount of space.  So a compromise was reached, and this compromise allowed english strings to stay at 1 byte per character (+ 2 extra bytes) and other languages would vary (up to 4 bytes) depending on where they fell in unicode.

| Min Code Point | Max Code Point | 1st Byte | 2nd Byte | 3rd Byte | 4th Byte|
| --- | --- | --- | --- | --- | --- | 
| U+000000 | U+00007F | 0xxxxxxx | | | |
| U+000080 | U+0007FF | 110xxxxx | 10xxxxxx | | |
| U+000800 | U+00FFFF | 1110xxxx | 10xxxxxx | 10xxxxxx | |
| U+010000 | U+10FFFF | 11110xxx | 10xxxxxx | 10xxxxxx | 10xxxxxx |

Essentially, the first byte of a UTF-8 character has several 1s followed by a 0.  The number of 1s represents the number of bytes used to represent that character.  The x's are the bits that represent the code point.  But wait, there's a slight problem (remember two extra bytes).  How do we know if we are using big-endian or little-endian?  Every UTF-8 string is prepended with `0xFEFF`.  If you're using little-endian, this would appear as `0xFFFE`.

### UTF-16

UTF-16 was an attempt to make UTF-8 more efficient for international langauges.  The 16 here represents the block size.  Rather than use 8 bit blocks (to keep the ASCII folks happy), UTF-16 said we'll use 16 bits instead.  This actually simplifies UTF-16 a great deal (for U+000000 to U+00FFFF).  If your strings have more international characters, you can actually save space with UTF-16!.