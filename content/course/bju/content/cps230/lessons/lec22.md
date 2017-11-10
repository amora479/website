---
title: "CPS 230 Lecture 22"
---

# Lecture 22: Co-operative Tasks

Today's lecture is going to be a different.  We're going to discuss how to accomplish something (or rather simulate something) that is actually impossible on older comptuers.  That is... multitasking.

## Modern Processor Architectures

Modern processors can actually run multiple threads of execution in parallel, but this is because of the advent of multi-core architectures.  Each thread can be assigned to a core, and the cores run the tasks in a true parallel fashion.  However, we've had multitasking on computers since before the advent of multicore machines, or at least it has looked like we did.

## Multitasking Without Multitasking

On older processors with a single core, you can achieve what looks like multitasking by periodically switching between tasks.  As long as the processor is fast enough and you make sure that each task is getting adequate time, the only discernable difference is that your task takes a bit longer to execute.

## Two Types

There are two types of multitasking: preemptive and cooperative.  Preemptive means that the processor gets to define how many clock cycles you get to execute and then it sends a signal alerting the task that its time is up and the processor is switching tasks.  Cooperative multitasking means that you place "yield" statements periodically in your code.  When a yield is executed, you tell the processor you're at a good place to stop and someone else can run for a bit.

Cooperative multitasking is actually easier to accomplish so we'll write a program that runs two tasks, A and B.  Each task will be rather simple.  It will print "I am task A/B" then yield.  Our setup, though, will support up to 32 tasks.

Note:  This example is going to be quite involved with a lot of parts.  I will call out the parts individually and explain them as we go, then the full example will be listed at the end of the notes.

## Example

### What does a program really need to run?

### Saving Registers / Stacks

### Switching 

### Yielding

## Full Example

``` asm

```