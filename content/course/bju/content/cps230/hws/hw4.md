---
title: "CPS 230 HW 4"
---

# Homework 4: Linking
## Linking

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
For each relocation (in order of "site"), indicate the source section, offset in source section, final loaded address ("site"), target symbol name, original (pre-fixup) 32-bit hex value, and adjusted (post-fixup) 32-bit hex value.

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

Using a *hex editor* of your choice, construct the sequence of bytes produced by linking the given given object files, saving it as **image.bin** and submitting it electronically.  **image.bin** should be exactly 96 bytes long and should have an MD5 checksum of **8c000ff2879e019a24f262da4000ee8e**.

## Source Files

For your reading pleasure, see the NASM source files from which your object files were assembled.  (Just as a real-life linker never looks at the original source code, you don't *need* to see these files to complete this assignment. But comparing the original source to the resulting object file is an enlightening experience.)

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
    push    ebp
    mov     ebp, esp

    push    dword [helicopter]
    call    _chisel
    add     esp, 4

    pop     ebp
    ret

section .data
    db 0,0
helicopter  dd  0x64
    db 0,0,0,0,0,0
global golf_cart
golf_cart  dd  0xe1
```

### bat.asm
``` asm
extern _drill
extern golf_cart

section .text
    int3
    int3

global _chisel
_chisel:
    mov eax, [plum]
    xor eax, [golf_cart]
    ret

    int3
    int3

global _wrench
_wrench:
    mov eax, [golf_cart]
    add eax, [pineapple]
    ret


section .data
pineapple  dd  0x1db
plum  dd  _drill
```

### fox.obj
#### .text Section Bytes/Relocations
``` asm
00000000: CC CC CC 55 89 E5 FF 35  02 00 00 00 E8 00 00 00  ...U...5........
00000010: 00 83 C4 04 5D C3                                 ....].
```

| Offset | Kind | Target Symbol |
| --- | --- | --- |
| 8 | DIR32 | **fox.data** |
| 13 | REL32 | **_chisel** |

#### .data Section Bytes/Relocations
``` asm
00000000: 00 00 64 00 00 00 00 00  00 00 00 00 E1 00 00 00  ..d.............
```

*(no relocations for this section)*

#### Public/External Symbols
| Section | Offset | Name |
| --- | --- | --- |
| **&lt;external&gt;** | 0 | **_chisel** |
| **&lt;external&gt;** | 0 | **_wrench** |
| **fox.text** | 3 | **_drill** |
| **fox.data** | 12 | **golf_cart** |

### Module bat.obj
#### .text Section Bytes/Relocations
``` asm
00000000: CC CC A1 04 00 00 00 33  05 00 00 00 00 C3 CC CC  .......3........
00000010: A1 00 00 00 00 03 05 00  00 00 00 C3              ............
```

| Offset | Kind | Target Symbol |
| --- | --- | --- |
| 3 | DIR32 | **bat.data** |
| 9 | DIR32 | **golf_cart** |
| 17 | DIR32 | **golf_cart** |
| 23 | DIR32 | **bat.data** |

#### .data Section Bytes/Relocations
``` asm
00000000: DB 01 00 00 00 00 00 00                           ........
```

| Offset | Kind | Target Symbol |
| --- | --- | --- |
| 4 | DIR32 | **_drill** |


#### Public/External Symbols
| Section | Offset | Name |
| --- | --- | --- |
| **&lt;external&gt;** | 0 | **_drill** |
| **&lt;external&gt;** | 0 | **golf_cart** |
| **bat.text** | 2 | **_chisel** |
| **bat.text** | 16 | **_wrench** |