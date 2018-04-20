# Writing DOS Programs in Real Mode C

## Getting Borland Turbo C for DOS

There aren't many C compilers left that produce native 8086, but the ones from the dos era most certainly do!

We'll be using Turbo C, a C compiler from the DOS era.  Download the [TurboC.zip](/course/bju/content/cps230/downloads/TurboC.zip) and extract it into the same folder as DosBox-X. 

Inside the `TurboC` folder, there is a `TC` folder, cut / paste this folder to the same  directory as the DosBox-X executable.  You can delete the TurboC directory after doing this.

## Getting Borland Turbo Assembler for DOS

We'll also need a DOS era assembler to compile C with in-line assembly.  Download the [TASM.zip](/course/bju/content/cps230/downloads/TASM.zip) and extract it into the same folder as DosBox-X. Mount the first image `Disk1.img` as an image (choose Floppy when picking the type) as any drive (I used B:). 

1. Change to B with `B:`
1. Run `install.exe`
1. At some point, the install will fail due to examples, that's fine.  Just abort at that point.
1. Restart DosBox-X, and remount `C:\DosBox-X` as `C:`

## A Sample C Program

Save this C example (I named it `temp.c`) and mount the folder containing it (I used D:).

```c
void drawpixel(int x, int y, int color) 
{
	asm push ax;
	asm push bx;
	asm push cx;
	asm push dx;
	asm mov ah, 0x0C
	asm mov al, [bp + 8]
	asm mov cx, [bp + 6]
	asm mov dx, [bp + 4]
	asm int 0x10
	asm pop dx;
	asm pop cx;
	asm pop bx;
	asm pop dx;
}

void drawline() {
	int x = 0, y = 0;
	int x_increment = 1, y_increment = 1;

	for(;;) {
		if(x == 0) {
			x_increment = 1;
		} else if (x == 200) { 
			x_increment = 0;
		}
		if(y == 0) {
			y_increment = 1;
		} else if (y == 320) { 
			y_increment = 0; 
		}
		if(x_increment) {
			x = x + 1;
		} else {
			x = x - 1;
		}
		if(y_increment) {
			y = y + 1;
		} else {
			y = y - 1;
		}
		drawpixel(x, y, 7);
	}
}

void main() {
	asm mov ah, 0;
	asm mov al, 0x13;
	asm int 0x10;

	drawline();
}
```

Before compiling, we need to put TCC and TASM into the path using the command `SET PATH=%PATH%;C:\TC;C:\TASM`. Type `TCC` and `TASM` at the command line to make sure both are now available. (You will need to do this every time you close and open DosBox-X).

To compile with the command line, change to the D drive with `D:` and run the command `TCC.EXE -B TEMP.C`.  An exe should be created in the same directory.

## Explaining Turbo C Inline Assembly

If you do a Google search, you might see notes that you can use `asm { <assembly instructions> }` with Turbo C.  The cake is a lie, that feature was introduced in 3.0.  We are stuck with 2.1 which requires you to enter your assembly line by line putting `asm` before each line.  Still, its not too terrible.

## Other Notes

This is a very, very old version of C and all of the nice new features you might have enjoyed using earlier in the semester might not exist.  For the authoritative source on what is available and what isn't, see the [Turbo C User Manual](/course/bju/content/cps230/downloads/turbocdoc.pdf).