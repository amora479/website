---
title: "CPS 105"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Why Take Computer Foundations?

The purpose of the course is:

- to give you a broad overview of the field of computer science including:

    - computer science basics
    - algorithms
    - current trends
    - relating the bible to computer science

- if you are computer science / IT major, this course will help lay the groundwork for later courses in your college career
- if you are not a computer science major, this course will help prepare you to use technology effectively and biblically in the workplace

# Why?

Well, I already know how to turn them on, open a web browser, and get to Google. What more do I need?  Let me ask the question, **Do you know how any of that works?**  If your normal process of getting to Google were to fail, would you be able to accurately articulate in an understandable way: 1) what your normal process is, 2) where your normal process failed, 3) if any abnormalities were present during the parts of the process that worked, and 4) what you attempted to do to resolve the issue before asking for help.

# Fingerprint Scanners

Let's take a process that is computer based, but a little bit easier to understand than "What steps are involved when I turn on the computer and go to Google?"  We will get to most of those steps thoughout the semester. 

Fingerprint scanners are ubiquitous today.  You seem them in airports to confirm identity.  They are on phones and laptops.  You probably use them (and somewhat trust them) on a daily basis. But do you know how the fingerprint scanner determines that the finger it is reading is indeed you?

## Types

To start, there are 5 (technically 6) types of fingerprints.  There is the arch, left loop, right loop, tented arch (usually merged with arch because they look similiar), twin loop and whorl.

To determine your fingerprint type, pick a finger and look closely at the ridges.  Look for triangles and whirls.  (Note: each of your fingers might be different types.)

If you have two triangles and the middle of the whirl area forms true complete circles, its a whorl.

![Whorl](/bju/cps105/lectures/lec0-images/whorl.gif)

If you have two triangles but the circles aren't complete then its a twin loop.

![Twin Loop](/bju/cps105/lectures/lec0-images/twin-loop.jpg)

If you have one triangle on the right side, its a left loop.  If you have one triangle on the left side, its a right loop.

![Left Loop](/bju/cps105/lectures/lec0-images/left-loop.jpg)

If you have one triangle, in the middle, with no whorl, then its a tented arch.

![Tented Arch](/bju/cps105/lectures/lec0-images/tented-arch.jpg)

If you have no triangles, or your fingerprint doesn't fit any of the above categories, then its an arch.

## Matching

If you look very closely at your fingerprint, you'll notice something interesting about the ridges themselves.  They occasionally terminate (called ridge ending) or split into two ridges (called bifurcation).  The locations where ridges terminate or split are what we use for matching fingerprints (or specifically the location).

Readers take the endings and splits as well as their location and turn them into a coordinates on a graph.

For example, if the left most triangle is at 0,0, then you might have a ridge split at 3,6.  Take the fingerprint type as well as a set of ending / split locations and you've got everything you need to determine if a fingerprint belongs to a person.

How many ending / split locations do you think would be needed, in a court of law, to determine that a person committed a crime?  How many do you think your phone needs to determine that you are the owner of the phone?