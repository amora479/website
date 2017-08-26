\documentclass{article}
\usepackage[margin=2cm,nohead]{geometry}
\usepackage{verbatim}
\usepackage{listings}
\usepackage{multicol}

\title{CpS 230 Homework 4: Linking}
\author{Specially Prepared for Mr. Carter (acart976)}
\date{~}

\pagenumbering{gobble}

\begin{document}

\maketitle

\section*{Linking}

\noindent
You will ``link'' (by hand) 2 provided object files \textit{(see final page)} into a single binary image
that will be loaded/executed at address \textbf{0x8d53400} in memory.

\pagebreak[0]
\subsection*{1. Concatenate Sections \textit{(5 pts)}}

\noindent
Fill in the following table indicating where in memory each section from each object file will be located.
Enter both the \textit{relative offset} (starting at 0) and the \textit{loaded address} (i.e., $base + offset$).
Align all sections on 16-byte boundaries (i.e., all the starting addresses should end in ``\texttt{0}'' in hex).

\vspace{0.1in}

\begin{tabular}{ l | c | c }
\textbf{Module/Section} & \textbf{Relative Offset} & \textbf{Loaded Address} \\
\hline
\verb!bat.text! & \phantom{0} & \phantom{0x8d53400} \\
\hline
\verb!fox.text! & \phantom{32} & \phantom{0x8d53420} \\
\hline
\verb!bat.data! & \phantom{64} & \phantom{0x8d53440} \\
\hline
\verb!fox.data! & \phantom{80} & \phantom{0x8d53450} \\
\end{tabular}

\pagebreak[0]
\subsection*{2. Resolve Symbols \textit{(10 pts)}}

\noindent
Indicate the name, source section, offset in source section, and final loaded address of each public symbol,
in order of final loaded address.

\vspace{0.1in}

\begin{tabular}{ l | l | c | c }
\textbf{Symbol} & \textbf{From} & \textbf{Offset} & \textbf{Loaded Address} \\
\hline
\phantom{\_chisel} & \phantom{bat.text} & \phantom{2} & \phantom{0x8d53402} \\
\hline
\phantom{\_wrench} & \phantom{bat.text} & \phantom{16} & \phantom{0x8d53410} \\
\hline
\phantom{\_drill} & \phantom{fox.text} & \phantom{3} & \phantom{0x8d53423} \\
\hline
\phantom{golf\_cart} & \phantom{fox.data} & \phantom{12} & \phantom{0x8d5345c} \\
\end{tabular}


\pagebreak[0]
\subsection*{3. Apply Relocations \textit{(15 pts)}}

\noindent
For each relocation (in order of ``site''), indicate the source section,
offset in source section, final loaded address (``site''), target symbol name,
original (pre-fixup) 32-bit hex value, and adjusted (post-fixup) 32-bit hex value.

\vspace{0.1in}

\begin{tabular}{ l | c | c | l | l | c | c }
\textbf{Section} & \textbf{Offset} & \textbf{Site} & \textbf{Target} & \textbf{Kind} & \textbf{Orignal Value} & \textbf{Adjusted Value} \\
\hline
\phantom{bat.text} & \phantom{3} & \phantom{0x8d53403} & \phantom{bat.data} & \phantom{DIR32} & \phantom{0x4} & \phantom{0x8d53444} \\
\hline
\phantom{bat.text} & \phantom{9} & \phantom{0x8d53409} & \phantom{golf\_cart} & \phantom{DIR32} & \phantom{0x0} & \phantom{0x8d5345c} \\
\hline
\phantom{bat.text} & \phantom{17} & \phantom{0x8d53411} & \phantom{golf\_cart} & \phantom{DIR32} & \phantom{0x0} & \phantom{0x8d5345c} \\
\hline
\phantom{bat.text} & \phantom{23} & \phantom{0x8d53417} & \phantom{bat.data} & \phantom{DIR32} & \phantom{0x0} & \phantom{0x8d53440} \\
\hline
\phantom{fox.text} & \phantom{8} & \phantom{0x8d53428} & \phantom{fox.data} & \phantom{DIR32} & \phantom{0x2} & \phantom{0x8d53452} \\
\hline
\phantom{fox.text} & \phantom{13} & \phantom{0x8d5342d} & \phantom{\_chisel} & \phantom{REL32} & \phantom{0x0} & \phantom{0xffffffd1} \\
\hline
\phantom{bat.data} & \phantom{4} & \phantom{0x8d53444} & \phantom{\_drill} & \phantom{DIR32} & \phantom{0x0} & \phantom{0x8d53423} \\
\end{tabular}

\pagebreak[0]
\subsection*{4. Generate Final Image  \textit{(10 pts)}}

\noindent
Using a \textit{hex editor} of your choice, construct the sequence of bytes
produced by linking the given given object files, saving it as \verb!image.bin! and
submitting it electronically.  \verb!image.bin! should be exactly 96 bytes long and should
have an MD5 checksum of \texttt{8c000ff2879e019a24f262da4000ee8e}.

\clearpage

\section*{Source Files}

\noindent
For your reading pleasure, see the NASM source files from which your object files
were assembled.  (Just as a real-life linker never looks at the original source
code, you don't \textit{need} to see these files to complete this assignment.
But comparing the original source to the resulting object file is an enlightening experience. \verb!:-)!)

\begin{multicols}{2}

\subsection*{``fox.asm''}
\begin{lstlisting}[language={[x86masm]Assembler}]
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


\end{lstlisting}


\subsection*{``bat.asm''}
\begin{lstlisting}[language={[x86masm]Assembler}]
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


\end{lstlisting}


\end{multicols}

\clearpage

\section*{Object Files}

\subsection*{Module ``fox.obj''}
\scriptsize

\subsubsection*{.text Section Bytes/Relocations}

% Hexdump of .text section
\begin{verbatim}
00000000: CC CC CC 55 89 E5 FF 35  02 00 00 00 E8 00 00 00  ...U...5........
00000010: 00 83 C4 04 5D C3                                 ....].
\end{verbatim}

% .text section relocation table
\noindent
\begin{tabular}{ r | c | l }
Offset & Kind & Target Symbol \\
\hline
8 & DIR32 & \verb@fox.data@ \\
13 & REL32 & \verb@_chisel@ \\
\end{tabular}


\vspace{0.25in}
\subsubsection*{.data Section Bytes/Relocations}

% Hexdump of .data section
\begin{verbatim}
00000000: 00 00 64 00 00 00 00 00  00 00 00 00 E1 00 00 00  ..d.............
\end{verbatim}

% .data section relocation table
\noindent
\begin{tabular}{ r | c | l }
Offset & Kind & Target Symbol \\
\hline
\end{tabular}

\noindent
\textit{(no relocations for this section)}


\vspace{0.25in}
% Module-wide [external] symbol table
\subsubsection*{Public/External Symbols}
\begin{tabular}{ l | c | l }
Section & Offset & Name \\
\hline
\verb@<external>@ & 0 & \verb@_chisel@ \\
\verb@<external>@ & 0 & \verb@_wrench@ \\
\verb@fox.text@ & 3 & \verb@_drill@ \\
\verb@fox.data@ & 12 & \verb@golf_cart@ \\
\end{tabular}


\vspace{1in}

\subsection*{Module ``bat.obj''}
\scriptsize

\subsubsection*{.text Section Bytes/Relocations}

% Hexdump of .text section
\begin{verbatim}
00000000: CC CC A1 04 00 00 00 33  05 00 00 00 00 C3 CC CC  .......3........
00000010: A1 00 00 00 00 03 05 00  00 00 00 C3              ............
\end{verbatim}

% .text section relocation table
\noindent
\begin{tabular}{ r | c | l }
Offset & Kind & Target Symbol \\
\hline
3 & DIR32 & \verb@bat.data@ \\
9 & DIR32 & \verb@golf_cart@ \\
17 & DIR32 & \verb@golf_cart@ \\
23 & DIR32 & \verb@bat.data@ \\
\end{tabular}


\vspace{0.25in}
\subsubsection*{.data Section Bytes/Relocations}

% Hexdump of .data section
\begin{verbatim}
00000000: DB 01 00 00 00 00 00 00                           ........
\end{verbatim}

% .data section relocation table
\noindent
\begin{tabular}{ r | c | l }
Offset & Kind & Target Symbol \\
\hline
4 & DIR32 & \verb@_drill@ \\
\end{tabular}



\vspace{0.25in}
% Module-wide [external] symbol table
\subsubsection*{Public/External Symbols}
\begin{tabular}{ l | c | l }
Section & Offset & Name \\
\hline
\verb@<external>@ & 0 & \verb@_drill@ \\
\verb@<external>@ & 0 & \verb@golf_cart@ \\
\verb@bat.text@ & 2 & \verb@_chisel@ \\
\verb@bat.text@ & 16 & \verb@_wrench@ \\
\end{tabular}


\clearpage

\phantom{this page left blank on purpose}

\end{document}

