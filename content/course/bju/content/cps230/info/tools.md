---
title: Software Tools
layout: page
category: toc
---

This course makes heavy use of several software tools.
All of them are freely available to you, and you should make sure you have them handy as soon as possible.

## Needed right away

* Microsoft Windows
    - Preferably Windows 10
    - If you don't wish to install it natively, you can run it in a VM
    - Available to you free of charge via MSDNAA (see the CS lab monitors for details)

* Microsoft Visual Studio 2015
    - The free [community edition](https://www.visualstudio.com/products/visual-studio-community-vs) is fine
    - Or you can get the professional/enterprise versions, also for free, via MSDNAA (see the CS lab monitors for details)
    - **Either way**, make sure you install the C++ tools and project templates (which are not enabled by default)

> **Note**
>
> In many CpS classes, the operating system and tools used are chosen for convenience
> and may be substituted by daring/self-reliant students willing to figure out the
> alternatives for themselves.
>
> *This is not one of those classes.*
>
> The nature of this class means that details which typically don't matter in other classes
> (e.g., C/C++ calling conventions) will matter *very much* to us, and for sanity's sake
> these details need to be standardized.  For various reasons (including making your life
> easier, actually), the instructor has chosen Windows as the platform of record in this
> class.  Therefore, you will need it if you don't already have it.


## Needed Before Too Long

* NASM (the Netwide Assembler)
    - v2.12.02 (or later)
    - If the installer asks, you *don't* need either "RDOFF" support or "VS8 Integration"

* DOSBox (with the integrated debugger)
    - *The normal DOSBox installer typically doesn't give you this!*
    - You can build DOSBox from source to get the debugger [have fun!]
    - Or you can download this [ZIP file]({{site.baseurl}}/downloads/dbd.zip)
    - Either way, I will assume you installed the executable at `C:\cps230\bin\dbd.exe` (you're free to put it somewhere else, just remember to translate the instructions appropriately)
