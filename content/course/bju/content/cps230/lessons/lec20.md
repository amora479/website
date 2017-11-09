---
title: "CPS 230 Lecture 20"
---

# Lecture 20: Real Mode Addresses

We've mentioned a few times now that the Intel 8088 (which DoxBox is emulating) uses 16-bit registers and 20-bit addresses (which allow it to reference 1 mb or memory instead of the 64k).  We'll now unviel how that happens.

## 8088 Memory Layout

Memory is laid out, for the 8088, in 65536 65536-byte chunks.  But wait, you might say, that is way more than 1 mb, and you would be correct.  The layout isn't so simple.

``` text
0x0          0x10         0x20
|            |            |
| Segment  1 |            |
|  16 bytes  |            |
|            |            |
             |            |
             | Segment  2 |
             |  16 bytes  |
             |            |
                          |            
                          | Segment  3 
                          |  16 bytes  
                          |            
```

From the diagram above, each segment begins precisely 16 bytes after the segment before it and then continues for 65536 bytes before it terminates.  You might ask why this insanity.

At the time, the 65536 byte limitation on memory was getting to be a problem.  Other manufacturers had come up with some pretty creative solutions.  You could buy a piece of hardware, a "bank", to attach to your machine that would essentially double the amount of memory you had available.  Then you simply flipped a switch programmatically to switch between "banks".

Intel wanted something simpler but that also provided more space than the competition.  So this 20-bit scheme that provided 1mb of memory was introduced.  This scheme is also known as "real-mode addressing", you can actually enable it on pretty much any modern intel processor if you really want to.

## Calculating Addresses

So now that we know how the memory is laid out, time to figure out how to build an address.  To do that, we'll need registers we've used before (at least sorta).  When we did string operations without C, we instroduced the segment offset registers.  The Intel 8088 has 6 of them:
* CS (Code Segment) - this register points to the segment that contains the instructions for the currently executing program
* DS (Data Segment) - this register points to the segment that contains the data (global variables) for the currently executing program
* SS (Stack Segment) - this register points to the segment that contains the instructions for the currently executing program
* ES (Extra Special Segment) - this register is used for a couple of things (but mainly copying data between segments)

When entering an instruction with an address (i.e. `mov ax, [0x100]`) one of the 4 segment registers is auto-inserted into the instruction address for you, unless you specify it yourself.  If your instruction is a call, the code segment register is used.  If your address is based on sp or bp, then the stack segment register is used.  Otheriwse, its the good ole data segment register.

Our previous instruction would therefore get transformed into `mov ax, [ds:0x100]`.  Note that the format for manual specificiation is `[segment:offset]`.  To calculate the 20-bit address, multiply the segment by 16 or 0x10 hex then add the offset.

Here are a few examples:

Let each of the following registers have the specified value: CS = 0x100, DS = 0x200, SS = 0x300, ES = 0x20, BX = 0x64, BP = 0x1337

| Original Instruction | Modified Instruction | Final Address |
| --- | --- | --- |
| mov ax, [0x100] | mov ax, [ds:0x100] | 0x02100 |
| mov ax, [bx] | mov ax, [ds:bx] | 0x02064 |
| mov ax, [bx + 4] | mov ax, [ds:bx + 4] | 0x02068 |
| mov ax, [es:0x4133] | mov ax, [es:0x4133] | 0x04333 |
| mov ax, [bp-4] | mov ax, [ss:bp-4] | 0x04333 |

## COM File Structure

One final thing to note.  We are writing COM files for DOS which is a special type of executable.  COM files are unique in two regards.  First, they can only be 65536 bytes long (which means they fit in a single segment).  Second they start with a 0x100 byte header that contains a couple of things (termination code, command line arguments).  The layout looks something like this:

``` text
0                  0x2                      0x100          0x100 + N           ..                   0x65536
|                  |                        |              |                                        |
| Termination Code | Command Line Arguments | Instructions | Global Data =>                <= Stack |
|                  |                        |              |                                        |
```

The size in particular should give you pause.  If the size is maxed at 65536 bytes, that means that CS = DS = SS!  It also means that if you push to much onto the stack, you can overwrite your global variables or even your instructions.  This is the reason why we're passing parameters via registers for now! 
