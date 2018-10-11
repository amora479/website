---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Homework 3

At the end of this assignment, you will find a code listing for a C program. Use it to answer all questions on the worksheet. Assume that the C compiler uses exactly the same (simple) rules for stack frame construction that we have studied in class.

## Stack Frame Chart

Fill out the following table so that it reflects the values on the stack at the moment line 6 is about to be executed.

* The ``value'' column should contain
    1. a numeric value (decimal) if the value can be known, or
    1. the string ``???'' if the value cannot be derived from the given information
* The ``description'' column should contain
    1. the name of the parameter/local variable stored in that slot, or
    1. a description of its special role (e.g., `saved RBP', `return address')
    
**We've discussed two methods of representing the stack.  One method involved creating shadow space and putting the first four params in registers. The second method involved just pushing all the parameters onto the stack.  You may use either method.**

| Address | Value | Description |
| --- | --- | --- |
| 11512 | ??? | saved RBP |
| 11504 | | |
| 11496 | | |
| 11488 | | |
| 11480 | | |
| 11472 | | |
| 11464 | | |
| 11456 | | |
| 11448 | | |
| 11440 | | |
| 11432 | | |

## Instruction Operands

Provide the missing operands for the following assembly instructions. Remember: in real life you will not know in advance the actual addresses at which local variables live, so reference them using a frame pointer or the stack pointer.  For the parameters, you may either consider them to be in registers or pushed to the stack.  **Complete only one of the sections below**

### Parameters in Registers Version

```
; Implementing line 6
mov     rax,             ; Get orange
and     rax, [        ]  ; Combine with pogo_stick
add     rsp, 8           ; Release local variable storage
pop     rbp              ; Restore previous frame pointer
ret                      ; Return to caller
```

```
; Implementing line 18
mov     rdx, [        ]  ; Pass crowbar
mov     rcx, [        ]  ; Pass rasp
call    _gnu
mov     [        ], rax  ; Move return value into drill
```

### Push Parameters to the Stack Version

```
; Implementing line 6
mov     rax, [        ]  ; Get orange
and     rax, [        ]  ; Combine with pogo_stick
add     rsp, 16          ; Release local variable storage
pop     rbp              ; Restore previous frame pointer
ret                      ; Return to caller
```

```
; Implementing line 18
push    qword [        ] ; Pass crowbar
push    qword [        ] ; Pass rasp
call    _gnu
add     rsp, 8           ; Remove parameters from stack
mov     [        ], rax  ; Move return value into drill
```

## Source Code
```
int gnu(int kumquat, int orange) {
    int pogo_stick = 7300;
    
    // ...
    
    return orange & pogo_stick;
}

int main() {
    int rasp = 8000;
    int crowbar = 500;
    int tape_measure = 8000;
    int screw_driver = 2700;
    int drill = 5900;
    
    // ...
    
    drill = gnu(rasp, crowbar);
    
    // ...
    
    return 0;
}
```
