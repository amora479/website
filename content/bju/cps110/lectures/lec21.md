---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# File System Processing

So, we know how to manipulate files... (well at least we can open them, change them and save them).  What about moving a file to a different directory, or renaming it?  Well, how do you do this in Windows / OS X / Linux first?

## Command Line Fun (Part II of N)

So on the command line, we've basically seen how to change directories (`cd`) and run python.  Well, we've also see IO redirection.  That was cool right?  How about renaming files?

```
move file1.txt file2.txt
- or for unix / os x people -
mv file1.txt file2.txt
```

Also works for directories.

```
move directory1 directory2
- or for unix / os x people -
mv directory1 directory2
```

We can also make copies of files.

```
copy file1.txt file2.txt
- or for unix / os x people -
cp file1.txt file2.txt
```

This also works for directories.

```
copy directory1 directory2
- or for unix / os x people -
cp directory1 directory2
```

Finally, we can delete file!

```
del file1.txt
- or for unix / os x people -
rm file1.txt
```

This also works for directories.

```
rmdir directory1
- or for unix / os x people -
rm -r directory1
```

You can also list files / folders in the current directory.

```
dir 
- or for unix / os x people -
ls
```

This also works if you want to list just the python files in the current directory.

```
dir *.py
- or for unix / os x people -
ls *.py
```

> Note: The star here is a substitute for anything.  This command would find chicken.py, turkey.py, pizza.py or <anything>.py in the current directory.  We will see the star again shortly.

## Enter Python

Literally all of the things we've done, have a Python equivalent.  For the most part, in the `os` module (although some are in the `shutil` module).

```py
import os
import shutil

shutil.move("src", "dest") # move a file
os.rename("src", "dest") # rename a file
shutil.copy("src", "dest") # copy a file
os.remove("file") # delete a file
os.removedirs("dir") # delete a directory
os.listdir("dir") # list the contents of a directory
```

Unlike in Windows, `os.listdir` doesn't tell us which things are a directory and which things are a file (and sometimes it is hard to tell).  But Python has a few helper functions that will tell us!  Here is a sample program that receives a directory as a command line argument and lists all the files and directories in that folder.

```py
import os
import sys

if len(sys.argv) < 2: # remember we always have one argument at 0 guaranteed
    print("I need a directory to work...", file=sys.stderr)
    print("Usage: python directorylister.py <folder>", file=sys.stderr)
    sys.exit()

print("Files")
print("====================")
for item in os.listdir(sys.argv[1]):
    if os.path.isfile(f"{sys.argv[1]}/{item}"): # this requires the full path, not just the file name
        print(item)
print()
print("Directories")
print("====================")
for item in os.listdir(sys.argv[1]):
    if os.path.isdir(f"{sys.argv[1]}/{item}"): # this requires the full path, not just the file name
        print(item)
```

What if we wanted to recursively get every folder underneath a folder?  For that, there is `os.walk`.

```py
import os
import sys

if len(sys.argv) < 2: # remember we always have one argument at 0 guaranteed
    print("I need a directory to work...", file=sys.stderr)
    print("Usage: python directorylister.py <folder>", file=sys.stderr)
    sys.exit()

for root, dirs, files in os.walk(sys.argv[1]):
    print(f"Listing for {root}")
    print("Files")
    print("====================")
    for item in files:
        print(item)
    print()
    print("Directories")
    print("====================")
    for item in dirs:
        print(item)
```

## Side Trip: List Comprehensions

List comprehensions are an alternative way of writing for loops in Python.  They are used and abused online regularly so if you're googling, you will run across them at some point.  But they are pretty simple.  The idea is that for loops typically are fairly simple.  Like this one...

```py
for item in os.listdir(sys.argv[1]):
    if os.path.isdir(f"{sys.argv[1]}/{item}"): # this requires the full path, not just the file name
        print(item)
```

so we could just rewrite it as...

```py
[print(item) for item in os.listdir(sys.argv[1]) if os.path.isdir(f"{sys.argv[1]}/{item}")]
```

Notice that all the elements of our for loop are still there, they just got shifted around a bit.  So if you run across a fairly nasty list comprehension online, you can just rewrite it as a for loop to make it more readable.

## List Files of a Pattern

Now if we want to find just the py files in a directory, things are a hair bit harder in Python.  We have to use the glob module!  The glob module has a glob method that takes a pattern string and returns only files or directories matching the pattern.  For example, let's say we wanted to rename every python file to chicken1, chicken2...

```py
import os
import sys
import glob

if len(sys.argv) < 2: # remember we always have one argument at 0 guaranteed
    print("I need a directory to work...", file=sys.stderr)
    print("Usage: python directorylister.py <folder>", file=sys.stderr)
    sys.exit()

chickenCount = 1
for item in glob.glob(f"{sys.argv[1]}/*.py"):
    os.rename(item, f"{sys.argv[1]}/chicken{chickenCount}.py")
    chickenCount += 1
```

Now that is for one directory.  What if you wanted to rename every python file in a directory and its subdirectories?  Well, glob has a directory matcher too, its ** instead of *.

```py
import os
import sys
import glob

if len(sys.argv) < 2: # remember we always have one argument at 0 guaranteed
    print("I need a directory to work...", file=sys.stderr)
    print("Usage: python directorylister.py <folder>", file=sys.stderr)
    sys.exit()

chickenCount = 1
for item in glob.glob(f"{sys.argv[1]}/**/*.py"):
    os.rename(item, f"{sys.argv[1]}/chicken{chickenCount}.py")
    chickenCount += 1
```