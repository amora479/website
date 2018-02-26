---
title: "CPS 230 HW 3"
---

# Homework 3: Stack Frames

At the end of this assignment, you will find a code listing for a C program. Use it to answer all questions on the worksheet. Assume that the C compiler uses exactly the same (simple) rules for stack frame construction that we have studied in class.

## Stack Frame Chart

Fill out the following table so that it reflects the values on the stack at the moment line 6 is about to be executed.

* The ``value'' column should contain
    1. a numeric value (decimal) if the value can be known, or
    1. the string ``???'' if the value cannot be derived from the given information
* The ``description'' column should contain
    1. the name of the parameter/local variable stored in that slot, or
    1. a description of its special role (e.g., `saved EBP', `return address')

| Address | Value | Description |
| --- | --- | --- |
| 11512 | ??? | saved EBP |
| 11508 | | |
| 11504 | | |
| 11500 | | |
| 11496 | | |
| 11492 | | |
| 11488 | | |
| 11484 | | |
| 11480 | | |
| 11476 | | |
| 11472 | | |

## Instruction Operands

Provide the missing operands for the following assembly instructions. Remember: in real life you will not know in advance the actual addresses at which parameters and local variables live, so you must use frame-pointer-relative addressing (i.e., _EBP + nn_ or _EBP - nn_).

```
; Implementing line 6
mov     eax, [        ]  ; Get orange
and     eax, [        ]  ; Combine with pogo_stick
add     esp, 4           ; Release local variable storage
pop     ebp              ; Restore previous frame pointer
ret                      ; Return to caller
```

```
; Implementing line 18
push    dword [        ] ; Pass crowbar
push    dword [        ] ; Pass rasp
call    _gnu
add     esp, 8           ; Remove parameters from stack
mov     [        ], eax  ; Move return value into drill
```

## Source Code
```
#include "stdio.h"

int gnu(int kumquat, int orange) {
    int pogo_stick = 7300;
    
    // ... (line 6)
    
    return orange & pogo_stick;
}

int main() {
    int rasp = 8000;
    int crowbar = 500;
    int tape_measure = 8000;
    int screw_driver = 2700;
    int drill = 5900;
    
    drill = gnu(rasp, crowbar); // line 18
    
    return 0;
}
```
