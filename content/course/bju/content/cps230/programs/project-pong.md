---
title: "Team Project: Pong"
---

# Team Project: Pong

## Overview

Note: This assignment is version of the kernel project but with the 4 independent tasks pre-specified.   As such, there is less room for creativity and a bit more work has to be completed up front. (a.k.a.  The alpha deliverable will be harder in this assignment while the final milestone will be easier.)

The alternate team project for this semester is the creation of a multi-tasking implementation of pong with 4 independent threads running different parts of the game.

**You should track how much time you each spend on this project.**  Include these totals in your final report!

See the overall project grading rubric [here](/course/bju/content/cps230/downloads/team_project_rubric.xlsx).

## Milestones

The project will be broken into 3 milestones: 2 "checkpoints" and the final deliverable.

### Alpha

Your rendition of pong should be packaged in a simple DOS executable (a `.COM` file).  In this version, you will have two separate tasks:

* Task 1 should draw to the screen (for this version, paddles, ball, and score are required) using ASCII art.  

* Task 2 will update game state (i.e. calculate the new location of the ball or paddles based on user input).  Note:  You cannot block for user input.  When the game state updater becomes active, read the input buffer and update accordingly, then yield when the buffer is empty.  For now, pick four keys on the keyboard.  Two keys to control the left paddle and two keys to control the right paddle.  The right paddle will eventually be controlled by a "simple" AI task.

You will have a global game state structure of your own definiton to pass data between the two tasks.

While the priority for the Alpha is the cooperative task switching, you should be giving thought to later milestones, and planning ahead for:

* More than 2 tasks at once (should be only a small generalization once you have 2 tasks working)

* Any "elective" features you want to complete (e.g., timer-preemption)

**Submission**: Submit 2 files to your group's bitbucket folder

* `kernel.asm`: the code for your Alpha-stage demo (I will assemble it with the command `nasm -fbin -okernel.com kernel.asm`)

* `README.txt`: a terse report including a list of any known bugs/issues and how many hours each team member has spent so far

### Beta

In this stage, you will write a bootloader that will load your kernel from sectors on the bootdisk into memory and start it running.

The bootloader will consist of a *first stage* bootloader residing in the first sector of a disk image.
It must include the **Master Boot Record** signature and take up *no more than 512* bytes.

It will load the kernel from sectors 2 through N (however many sectors your kernel ends up taking)
from the simulated disk and then execute it.
The kernel will be loaded into memory at address `0800:0000`.

The bootloader needs to *print your team members' names* and *prompt for a keypress* before running the kernel.

Note that since you are loading your own "operating system" from scratch here, you *cannot use DOS* (i.e., `int 0x21`) for anything.
At this point, *there is no DOS!*
(Well, that's not strictly true on DOSBox since DOSBox fakes everything.  But it would be true on a real vintage PC, so that's how
we're going to roll...)

**Much of this is already provided to you in incomplete form in Lab 9**.  So the Beta stage should not take much time in an of itself.

*Plan ahead!*

Use any extra time in this stage to get a jump start on any elective features you plan to do for the final stage.

**Submission**: Submit 4 files to your group's bitbucket folder

* `boot.asm`: the code for your bootloader itself

* `kernel.asm`: the code for your kernel demo code

* `bootdisk.img`: the complete floppy-disk image containing your bootloader/kernel combination

* `README.txt`: a terse report including a list of any known bugs/issues and how many hours each team member has spent so far

### Release (Final Deliverable)

This is it!  At this point you should already have:

* A kernel capable of multi-tasking at least 2 or more independent "threads" of execution (i.e., 2 or more different demo "programs")

* A bootloader capable of loading this kernel from disk and kicking it off without any help from DOS or user intervention

For this final stage you will:

* Extend your multi-tasking by adding two additional tasks: an AI and a score keeper.

* Make sure each task has at least **256 bytes** of dedicated stack space

* Fix any outstanding bugs

* Finish any elective features you wish to do (and you almost certainly will)

* Polish up your code (comments, etc.)

* Produce a succinct, informative, neatly-formatted team project report consisting of the following sections

    * Title page (including class name/number, project name, team members, and date)
    * Overview (brief abstract of the project goals, for readers unfamiliar with the project)
    * Results (list of required and elective features completed, along with any known bugs)
    * Details (brief overviews of your multi-tasking and bootloading logic, along with descriptions of your demo tasks)
    * Contributions (description of each team member's contributions, including total number of hours worked)
    * Appendix (complete source code printout)

**Submission**: Submit the following files to the bitbucket folder

* `boot.asm`

* `kernel.asm`

* `bootdisk.img`

AI Notes: The AI for your pong game should be extremely simple, but feel free to get more complex if you desire.  As a baseline, simply have the AI activate once the ball is a certain number of pixels away from paddle (for example, 10 pixels).  Have the paddle move as the ball moves. For example, if the ball moves 1 pixel down, the paddle should move one pixel down.  If the ball moves up one pixel, the paddle should move up one pixel.

If the ball is not within the pixel range or moving away from the paddle, the paddle remains still.  To ramp up the difficulty of your pong game, you can simply increase the pixel limit.

Score Keeper: The score keeper should simply check the location of the ball.  If it is at either end of the screen, the score keeper should update the score and drop the ball back in the middle of the screen moving towards the player who lost the last play.

## Teamwork

You must divide the work between yourselves as evenly as is possible/practical.  Communication is key (and is a component of your grade!).

In addition to a single team report, you will each individually *email* the instructor with a *personal*
report in which you will "grade" yourself and your teammate on

* communication (how well each member communicated intent/ideas to the other member)

* equity (how well each member pulled his/her own weight)

* unity (how well the members were able to work together, especially in the face of disagreement [which is inevitable])

## Basic Electives

Assuming no mistakes/bugs/omissions/errors of any kind at any point along the project,
completing the baseline/required features will earn your team **200** points out of **250**.

*Many* more points are available in the form of *elective* features from which you may pick and choose.  See below...

### Timer Preemption (25 pts)

Hook the timer interrupt (`INT 8`) vector and use this hook to *preemptively* switch tasks.

This will require several changes to your kernel:

* You will have to implement the interrupt hook itself (see Lab 10)

* You will have to modify how you switch tasks (because we are now "yielding" by way of interrupt rather than by way of normal function call)

* You will have to save/restore the segment registers (if you weren't already), since our "yield" may happen *while we are executing BIOS code that
    had temporarily changed the segment registers* (and we will need to restore that when we come back to the interrupted task)

* You will have to modify how you set up your "kickstart" stacks (because see above)

In particular, debugging will get harder once interrupts are involved.  But it's pretty cool to be able to remove all calls to `yield` from
your task code and watch the multi-tasking still work! 

### Music Demo (25 pts)

Use either the [PC speaker](http://qzx.com/pc-gpe/speaker.txt) or
[Adlib soundcard](http://qzx.com/pc-gpe/adlib.txt) (if you're a glutton for punishment)
to play the melody of the BJU alma mater in the background of your demos.

If you are *not* doing timer-preempted task switching, you will probably want to hook `INT 8` to provide smooth/lag-free music updates.  If you go this
route, you may even find that you need to [reprogram counter 0 on the PIT](http://stanislavs.org/helppc/8253.html)
to give you a faster interrupt frequency (so you can update notes more quickly).

If you *are* doing timer-preemption, this will be very challenging (you might have to have your timer interrupt hook doing double-duty; both
switching tasks *and* updating the current music notes).

## Challenge Electives

These are very challenging "stretch" goals for highly motivated teams that aren't afraid to research topics and solve problems for themselves.

For full credit, these ideas must be beyond the "proof of concept" phase and fully integrated with your bootloader/kernel/demos.

There is partial credit available for *bona fide* efforts along these lines that do not make it beyond the "proof of concept" phase.

### Graphics Demo (50 pts)

Have your Pong program display using VGA graphics rather than ugly ASCII text.

### Real-Mode C (50 pts)

Figure out how to use a 16-bit, real-mode-compatible C compiler (like OpenWatcom, or Digital Mars) to write at least some of your demo code in C.

### Protected Mode (50 pts)

Figure out how to switch the x86 into *protected mode* (full 32-bit addressing!)
before running your demos.  You won't be able to access the BIOS anymore (for all practical purposes), and interrupts will work very differently,
so you would have to change your preemptive task switching code substantially (or drop it all together).