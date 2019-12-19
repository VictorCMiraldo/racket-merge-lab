\section{Introduction}

Edit scripts are bad.
\victor{
\begin{itemize}
  \item Too much redundancy implies expensive algorithms.
  \item Too restrictive on opeations implies not being able to duplicate or permute.
  \item When coupled with line-based diff, merges are bad.
  \item Show a couple examples.
\end{itemize}}

\section{Extensional Approach}

  Instead of linearizing trees and relying on very local operations
such as insertion, deletions and copying of a single constructor, 
we can take the extensional look over patches and describe them by a mapping
between sets of trees. Lets look at a simple patch that deletes
the left subtree of a binary tree -- which
can be described by the |Del Bin (Del dots (Cpy dots Nil))| edit script.
A Haskell function that performs that operation can be given by:

\begin{myhs}
\begin{code}
delL (Bin _ x) = Just x
delL _         = Nothing
\end{code}
\end{myhs}

  The |delL| function specifies a domain





Take the patch that swaps the children of a binary tree
-- which is already impossible to represent with edit-scripts. It could be represented
by a Haskell function |swap|:

\begin{myhs}
\begin{code}
swap (Bin x y) = Just (Bin y x)
swap _         = Nothing
\end{code}
\end{myhs}

  This |swap| function has a pattern, which identifies the domain of
the function. In our case, we can only swap trees with a |Bin| constructor
at the root. That is, |dom swap| is given by:

\begin{myhs}
\begin{code}
dom swap = { Bin x y | x `elem` Tree , y `elem` Tree }
\end{code}
\end{myhs}

  Then, to each tree in the domain we assign a transformed tree. In this case,
it is 



lorem ipsum dolor sit 

%%% Local Variables:
%%% mode: latex
%%% TeX-master: t
%%% End: 
