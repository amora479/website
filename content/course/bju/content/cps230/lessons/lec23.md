---
title: "CPS 230 Lecture 23"
---

# Lecture 23: Booting

## A Few Notes About Disks

There are a couple of terms that you need to be familiar with.

* RAM (Random Access Memory) - this is the typical memory that we deal with.  It is also known as volitale memory because its state is not guaranteed between reboots
* ROM (Read Only Memory) - this is memory that once written cannot be changed.  Well, that is the hope; it can actually be changed, but doing so is risky as generally involves modifying hardware or using magnets. For our purposes, ROM contains the hardware manufacturer's code that is used to test hardware prior to loading the OS.
* Disk - this are rewriteable memory stores whose state is guaranteed between reboots.  Examples are your hard drive, USB sticks or (in our case) floppy disks!  Yup, we're going to be using floppy disks; they were pretty popular back when dos was around after all.

All disks are divided into sectors (with each sector being the same size).  For bootable disks, the first sector (strangely index 1 not 0!), contains a bit of code that loads the OS or program contained on the disk.  In the case of floppies, sectors are 512 bytes so all of our loading code must fit in that space.

## Booting

PCs have a very involved boot process.  Below are most of the steps of the cold boot process (or the power button press event procedure).  I'll comment on them, but the one we are most concerned with is the last step!

* CS:IP are set to FFFF:0000 (address of ROM POST code)
	
	For the Intel 5150 (and most DOS machines), the last segment of memory is write protected memory that contains boot code.  This has the implication that all of the boot code for DOS machines (hardware testing, data, assembly, etc) has fit in 64k of memory.

* jump to CS:IP  (execute POST, Power On Self test)
* interrupts are disabled

	Interrupts are useful, but you probably don't want to interrupt the boot process.  It would be bad if you installed a faulty keyboard driver and from then on if you pressed a key before the boot finished the machine hung, right?

* CPU flags are set, read/write/read test of CPU registers

	If these guys don't work, there's no point in the boot completing, because we won't be able to do any task reliably.

* checksum test of ROM BIOS

	Make sure that someone hasn't put a virus / malicious code into ROM.

* Initialize DMA (verify/init 8237 timer, begin DMA RAM refresh)
* save reset flag then read/write test the first 32K of memory
* Initialize the Programmable Interrupt Controller (8259) and set 8 major BIOS interrupt vectors (interrupts 10h-17h)
* determine and set configuration information

	The configuration is mainly checking to see if you have any hardware additions.  Remember, you could buy memory banks to expand your available memory in these days.

* initialize/test CRT controller & test video memory (unless 1234h found in reset word)
* test 8259 Programmable Interrupt Controller
* test Programmable Interrupt Timer (8253)
* reset/enable keyboard, verify scan code (AAh), clear keyboard, check for stuck keys, setup interrupt vector lookup table
* hardware interrupt vectors are set
* test for expansion box, test additional RAM
* read/write memory above 32K (unless 1234h found in reset word)
* addresses C800:0 through F400:0 are scanned in 2Kb blocks in search of valid ROM.	If found, a far call to byte 3 of the ROM is executed.
* test ROM cassette BASIC (checksum test)
* test for installed diskette drives & FDC recalibration & seek
* test printer and RS-232 ports.  store printer port addresses at 400h and RS-232 port addresses at 408h.  store printer time-out values at 478h and Serial time-out values at 47Ch.
* NMI interrupts are enabled
* perform INT 19 (bootstrap loader), pass control to boot record or cassette BASIC if no bootable disk found

## Reading from Disk

One thing to remember, the only segment register that you are guaranteed to have set in a bootloader is the CS register.  The only other value you are guaranteed to have is in DL.  That value is the current disk's #.  All other registers probably have gibberish in them!

I'm not going to do a full example as you'll be writing a bootloader in lab 9.  Don't worry though, all of the specific steps are provided as comments.  I am going to show you how to do the most important part, reading from the floppy disk!  We'll need to use interrupt 13,2.

``` asm
mov ax, ds ; you might have to use another segment if ds doesn't contain the address you need
mov es, ax
mov ah, 2
mov al, 1 ; size of your payload in bytes divided by sector size (512)
mov ch, 0 ; floppies only have 1 track so easy to determine
mov cl, 2 ; mbr is in sector 1 so payload starts at 2
mov dh, 0 ; floppies only have 1 head so each to determine
mov dl, ? ; this is going to vary, remember that dl is probably the current disk, check the helppc reference if you need a different disk
mov bx, ? ; whatever offset you want to load
; we've used literally every general purpose register for parameters!
int 0x13
; the carry flag will be 0 if this worked, note disks are finicky and you may have to execute this a couple of times before it works
```