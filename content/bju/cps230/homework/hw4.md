---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Homework 4

You will "link" (by hand) 2 provided object files *(see final page)* into a single binary image that will be loaded/executed at address **0x8d53400** in memory.

## Concatenate Sections (5 points)

Fill in the following table indicating where in memory each section from each object file will be located. Enter both the *relative offset* (starting at 0) and the *loaded address* (i.e., $base + offset$). Align all sections on 16-byte boundaries (i.e., all the starting addresses should end in "0" in hex).

| Module/Section | Relative Offset | Loaded Address |
| --- | --- | --- |
| **bat.text** | | |
| **fox.text** | | |
| **bat.data** | | |
| **fox.data** | | |

## Resolve Symbols (10 points)

Indicate the name, source section, offset in source section, and final loaded address of each public symbol, in order of final loaded address.

| Symbol | From | Offset | Loaded Address |
| --- | --- | --- | --- |
| | | | |
| | | | |
| | | | |
| | | | |

## Apply Relocations (15 points)

\noindent
For each relocation (in order of "site"), indicate the source section, offset in source section, final loaded address ("site"), target symbol name, original (pre-fixup) 64-bit hex value, and adjusted (post-fixup) 64-bit hex value.

| Section | Offset | Site | Target | Kind | Orignal Value | Adjusted Value |
| --- | --- | --- | --- | --- | --- | --- |
| | | | | | | |
| | | | | | | |
| | | | | | | |
| | | | | | | |
| | | | | | | |
| | | | | | | |
| | | | | | | |

## Generate Final Image (10 pts)

Using a *hex editor* of your choice, construct the sequence of bytes produced by linking the given given object files, saving it as **image.bin** and submitting it electronically.  **image.bin** should be exactly 96 bytes long and should have an MD5 checksum of ****.

## Source Files

For your reading pleasure, see the NASM source files from which your object files were assembled.  (Just as a real-life linker never looks at the original source code, you don't *need* to see these files to complete this assignment. But comparing the original source to the resulting object file is an enlightening experience.)

### bat.asm
``` asm
extern _drill
extern golf_cart

section .text
    int3
    int3

global _chisel
_chisel:
    mov rax, [plum]
    xor rax, [golf_cart]
    ret

    int3
    int3

global _wrench
_wrench:
    mov rax, [golf_cart]
    add rax, [pineapple]
    ret


section .data
pineapple  dq  0x1db
plum  dq  _drill
```

### fox.asm
``` asm
extern _chisel
extern _wrench

section .text
    int3
    int3
    int3

global _drill
_drill:
    push    rbp
    mov     rbp, rsp

    mov     rcx, [helicopter]
    call    _chisel

    pop     rbp
    ret

section .data
    db 0,0
helicopter  dq  0x64
    db 0,0,0,0,0,0
global golf_cart
golf_cart  dq  0xe1
```

### Module bat.obj
#### .text Section Bytes/Relocations
``` asm
00000000: CC CC A1 04 00 00 00 00  00 00 00 33 05 00 00 00
00000010: 00 00 00 00 00 C3 CC CC  A1 00 00 00 00 00 00 00
00000010: 00 03 05 00 00 00 00 00  00 00 00 C3              
```

| Offset | Kind | Target Symbol |
| --- | --- | --- |
| 3 | DIR64 | **bat.data** |
| 13 | DIR64 | **golf_cart** |
| 25 | DIR64 | **golf_cart** |
| 35 | DIR64 | **bat.data** |

#### .data Section Bytes/Relocations
``` asm
00000000: DB 01 00 00 00 00 00 00  00 00 00 00 00 00 00 00
```

| Offset | Kind | Target Symbol |
| --- | --- | --- |
| 8 | DIR32 | **_drill** |

#### Public/External Symbols
| Section | Offset | Name |
| --- | --- | --- |
| **&lt;external&gt;** | 0 | **_drill** |
| **&lt;external&gt;** | 0 | **golf_cart** |
| **bat.text** | 2 | **_chisel** |
| **bat.text** | 24 | **_wrench** |

### fox.obj
#### .text Section Bytes/Relocations
``` asm
00000000: CC CC CC 55 89 E5 FF 35  02 00 00 00 00 00 00 00
00000010: E8 00 00 00 00 00 00 00  00 83 C4 04 5D C3
```

| Offset | Kind | Target Symbol |
| --- | --- | --- |
| 8 | DIR64 | **fox.data** |
| 17 | REL64 | **_chisel** |

#### .data Section Bytes/Relocations
``` asm
00000000: 00 00 64 00 00 00 00 00  00 00 00 00 00 00 00 00
00000010: E1 00 00 00 00 00 00 00  
```

*(no relocations for this section)*

#### Public/External Symbols
| Section | Offset | Name |
| --- | --- | --- |
| **&lt;external&gt;** | 0 | **_chisel** |
| **&lt;external&gt;** | 0 | **_wrench** |
| **fox.text** | 3 | **_drill** |
| **fox.data** | 16 | **golf_cart** |
