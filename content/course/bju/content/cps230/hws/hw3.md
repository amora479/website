\documentclass[12pt]{article}
\usepackage[margin=2cm,nohead]{geometry}
\usepackage{listings}

\title{CpS 230 Homework 3: Stack Frames}
\author{Specially Prepared for Mr. Carter (acart976)}
\date{~}

\pagenumbering{gobble}

\begin{document}

\maketitle

\noindent
On the last page of this assignment, you will find a code listing for a (randomly generated) C program.
Use it to answer all questions on the worksheet. Assume that the C compiler uses exactly
the same (simple) rules for stack frame construction that we
have studied in class.

\section{Stack Frame Chart}

\noindent
Fill out the following table so that it reflects the values on the stack
at the moment line 6 is about to be executed.

\begin{enumerate}
\item The ``value'' column should contain
    \begin{enumerate}
    \item a numeric value (decimal) if the value can be known, or
    \item the string ``???'' if the value cannot be derived from the given information
    \end{enumerate}
\item The ``description'' column should contain
    \begin{enumerate}
    \item the name of the parameter/local variable stored in that slot, or
    \item a description of its special role (e.g., `saved EBP', `return address')
    \end{enumerate}
\end{enumerate}

\vspace{.5in}

\begin{tabular}{ r | c | l }
\hline
Address & Value & Description \\
\hline
11512 & \phantom{abcd} ??? \phantom{abcd} & \phantom{abcd} saved EBP \phantom{abcd} \\
\hline
11508 & & \\
\hline
11504 & & \\
\hline
11500 & & \\
\hline
11496 & & \\
\hline
11492 & & \\
\hline
11488 & & \\
\hline
11484 & & \\
\hline
11480 & & \\
\hline
11476 & & \\
\hline
11472 & & \\
\end{tabular}    

\pagebreak
\section{Instruction Operands}

\noindent
Provide the missing operands for the following assembly instructions.
Remember: in real life you will not know in advance the actual addresses
at which parameters and local variables live, so you must use frame-pointer-relative
addressing (i.e., \texttt{EBP + nn} or \texttt{EBP - nn}).

\begin{lstlisting}[language={[x86masm]Assembler}]
; Implementing line 18
push    dword [        ] ; Pass crowbar
push    dword [        ] ; Pass rasp
call    _gnu
add     esp, 8           ; Remove parameters from stack
mov     [        ], eax  ; Move return value into drill
\end{lstlisting}

\begin{lstlisting}[language={[x86masm]Assembler}]
; Implementing line 6
mov     eax, [        ]  ; Get orange
and     eax, [        ]  ; Combine with pogo_stick
add     esp, 4          ; Release local variable storage
pop     ebp              ; Restore previous frame pointer
ret                      ; Return to caller
\end{lstlisting}

\section{Source Code}

\begin{lstlisting}[language=C, numbers=left]
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
\end{lstlisting}


\end{document}

