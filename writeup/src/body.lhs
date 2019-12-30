\section{Introduction}

Edit scripts are bad.
\victor{
\begin{itemize}
  \item Too much redundancy implies expensive algorithms.
  \item Too restrictive on opeations implies not being able to duplicate or permute.
  \item When coupled with line-based diff, merges are bad.
  \item Show a couple examples.
\end{itemize}}

We propose an extensional approach.

\section{Background}

\victor{Some edit-scripts; some about tree-diffing}

\victor{Primer on unification and substitution and term algebras}

\section{Extensional Patches}

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

  The |delL| function specifies a domain -- those trees with a |Bin| at their root --
and a transformation, which forgets the root and its left child.


\victor{still deciding the order of examples here... this is messy; pardon}


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

\newcommand{\termsof}[1]{\ensuremath{\mathcal{T}_{#1}}}
\newcommand{\patch}[2]{\ensuremath{#1 \mapsto #2}}
\newcommand{\pdel}[1]{\ensuremath{{#1}_d}}
\newcommand{\pins}[1]{\ensuremath{{#1}_i}}
\newcommand{\vars}[1]{\ensuremath{\mathbf{vars}\;#1}}
\newcommand{\app}[2]{\ensuremath{\mathbf{app}\;#1\;#2}}
\newcommand{\mgu}{\ensuremath{\mathbf{mgu}}}
\newcommand{\appAlpha}[3][\alpha]{\ensuremath{\mathbf{app}_{#1}\;#2\;#3}}

\newcommand{\after}[2]{\ensuremath{#1 \mathbin{\circ} #2}}

%format (patch (x) (y)) = "\patch{" x "}{" y "}"
%format (pdel (x))      = "\pdel{" x "}"
%format (pins (x))      = "\pins{" x "}"
%format after (p) (q)   = "\after{" p "}{" q "}"
%format app   p x       = "\app{" p "}{" x "}"

\begin{mydef}
  Let $\termsof{L}$ be the term algebra for the language $L$ augmented
with a countable set $V$ of variables. A patch $p =
\patch{\pdel{p}}{\pins{p}}$ consists in a pattern, $\pdel{p}$, and an
expression, $\pins{p}$ --- both elements of $\termsof{L}$ --- such
that $\vars{\pins{p}} \subseteq \vars{\pdel{p}}$.  We sometimes refer
to $\pdel{p}$ and $\pins{p}$ as the deletion and insertion contexts of
$p$.
\end{mydef}

\begin{mydef}
  We say an element $x \in \termsof{L}$ is a \emph{term} whenever 
$\vars{x} = \emptyset$.
\end{mydef}

  The \emph{swap} patch, for example, is represented by |patch (Bin x
y) (Bin y x)|, where |x| and |y| are taken from the set $V$ of variables.
Similarly to working with the $\lambda$-calculus, we
assume variable names never clash between patches.

\begin{mydef} 
\victor{application}
  Let $p$ be a patch over $\termsof{L}$ and $x$ a term over $\termsof{L}$,
we say $p$ applies to $x$ whenever $\pdel{p}$ unifies with $x$. Let
$\alpha$ be such substitution, the result of the application is $\alpha\;\pins{p}$.

\[ \app{p}{x} = y \iff \exists \alpha . \alpha\;\pdel{x} = \alpha\;x \wedge \alpha\;\pins{p} = y \]
\end{mydef}

  The identity patch is simply |patch x x|. 

\begin{lemma}
\victor{correctness of application}
  For all patch $p$ and term $x$, if $\app{p}{x} = y$ then $y$ is a term.
\end{lemma}
\begin{proof}
todo
\end{proof}

%format ~~ = "\approx"
  This notion of application gives rise to an extensional equality of patches.
We say patches $p$ and $q$ are equal, denoted $p \approx q$, whenever 
\[ \forall x . (\app{p}{x} = y \iff \app{q}{x} = z) \wedge y = z \]
It is easy to prove that $\approx$ above gives an equivalence relation.

\begin{mydef}
\victor{composition}
  Let $p$ and $q$ be patches we say that $p$ and $q$ compose whenever
$\pdel{p}$ unifies with $\pins{q}$ --- let $\sigma$ be such mgu. 
Given two patches $p$ and $q$ that compose,

| after p q = patch (sigma (pdel q)) (sigma (pins p))|
\end{mydef}

\begin{lemma}
\victor{composition is correct}
  Given $p$ and $q$ composable patches, |app (after p q) x = z| iff |app q x = y && app p y = z|.
\end{lemma}
\begin{proof}
transcribe from notebook
\end{proof}

\begin{lemma}
For any patch $p$, the identity patch |patch x x| is a left and right
identity to patch composition.
\end{lemma}
\begin{proof}
trivial
\end{proof}

\begin{lemma}
  Given $p$ and $q$ composable patches, let $\sigma = \mgu(\pdel{p} , \pins{q})$,
then there exists $\sigma_p, \sigma_q$ such that $\sigma = \sigma_p \cup \sigma_q$ and
$\sigma_p \; \pdel{p} = \sigma_q \; \pins{q}$.
\end{lemma}
\begin{proof}
Immediate since $\vars{p} \cap \vars{q} = \emptyset$.
\end{proof}

\begin{lemma}
  Given $p$ and $q$ composable patches, let $\sigma = \mgu(\pdel{p} , \pins{q})$,
then $\sigma$ is idempodent in $\pdel{q}$ and $\pins{p}$. That is, $\sigma\;\sigma\;\pdel{q} = \sigma\;\pdel{q}$
and similarly for $\pins{p}$.
\end{lemma}
\begin{proof}
transcribe
\end{proof}

  With these lemmas at hand, we can prove associativity of our
composition operator.

\begin{lemma}
Let $p$ and $q$ be composable patches. Let $r$ be a patch composable
with |after p q|. Then, $q$ and $r$ are composable and $p$ and |after q r|
are composable. Moreover, |after ((after p q)) r ~~ after p ((after r q))|
\end{lemma}
\begin{proof}
transcribe from notebook; somewhat long.
\end{proof}

\victor{I still have to talk about inverses, which is just swapping the deletion and insertion cotexts.}

  From these results, it follows that patches form a grupoid structure
over $\termsof{L}$, for any $L$.

  Yet, from a pratical standpoint, we composition might obfuscate
potential shares between the source and destination tree.

\section{Merging}

\victor{
\begin{itemize}
\item This construction of patches admits a merge operator.
\end{itemize}
}

\section{Experiments}

\victor{We are up to 30\% success rate on the dataset! yay}

\section{Discussion}

\subsection{The Case Against \emph{cost}}

\victor{\begin{itemize}
\item Defining the \emph{best} patch is difficult
\item The point of the cost, in ES, is to eliminate 
redundant operations. |cost (del c (ins c)) = 2|
whereas |cost (cpy c) = 0|
\item In our case, redundant copies might be present
as a byproduct of enforcing the sharing of subtrees.
\item From our experimental results, it seems that
patches that copy larger subtrees, closer to the root,
merge better. Hence, this could better guide a notionof optimality
\item We leave this as future work
\end{itemize}}

%%% Local Variables:
%%% mode: latex
%%% TeX-master: t
%%% End: 
