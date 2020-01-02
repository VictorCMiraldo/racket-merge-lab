\newcommand{\termsof}[1]{\ensuremath{\mathcal{T}_{#1}}}
\newcommand{\patch}[2]{\ensuremath{#1 \mapsto #2}}
\newcommand{\pdel}[1]{\ensuremath{\mathbf{del}\;{#1}}}
\newcommand{\pins}[1]{\ensuremath{\mathbf{ins}\;{#1}}}
\newcommand{\vars}[1]{\ensuremath{\mathbf{vars}\;#1}}
\newcommand{\app}[2]{\ensuremath{\mathbf{app}\;#1\;#2}}
\newcommand{\mgu}{\ensuremath{\mathbf{mgu}}}
\newcommand{\appAlpha}[3][\alpha]{\ensuremath{\mathbf{app}_{#1}\;#2\;#3}}
\newcommand{\after}[2]{\ensuremath{#1 \mathbin{\circ} #2}}


%format patch (x) (y) = "\patch{" x "}{" y "}"
%format pdel x      = "\pdel{" x "}"
%format pins x     = "\pins{" x "}"
%format after p q   = "\after{" p "}{" q "}"
%format app   p x       = "\app{" p "}{" x "}"
%format vars  x         = "\vars{" x "}"
%format sub             = "\subseteq"
%format #= = "\triangleq"
%format dot = "."
%format exists = "\exists"
%format (unifs a x y) = "{" x "} \cong_{" a "} {" y "}"
%format iff = "\iff"
%format sigma = "\sigma"
%format ~ = "\sim"




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

\section{Algebra of Extensional Patches}

  Instead of linearizing trees and relying on very local operations
such as insertion, deletions and copying of a single constructor, we
can take an extensional look over patches: describing patches
directly as a partial map. Take the patch that deletes
the left subtree of a binary tree -- which can be described by the
|Del Bin (Del dots (Cpy dots Nil))| edit script.  A Haskell function
that performs that operation can be given by:

\begin{myhs}
\begin{code}
delL (Bin _ x) = Just x
delL _         = Nothing
\end{code}
\end{myhs}

  The |delL| function specifies a domain -- those trees with a |Bin|
at their root -- and a transformation, which forgets the root and its
left child, returning only the right child of the root. One way of
representing this is by |patch (Bin y x) x|, where |x| and |y| are variables,
which are bound on the \emph{deletion context} of the patch and
used on the \emph{insertion context} of the patch.
\victor{the ES variant fixes the left subtree; we can make it
in such a way that we don't... I need to really figure the 
details of this before writing it up though.}

  Let us look at another example: the patch that swaps the children of
a binary tree -- which is already impossible to represent with
edit-scripts. It could be represented by a Haskell function below,
or by |patch (Bin x y) (Bin y x)|.

\begin{myhs}
\begin{code}
swap (Bin x y) = Just (Bin y x)
swap _         = Nothing
\end{code}
\end{myhs}

  In the examples above, we have informally described extensional patches
over a simple \emph{term algebra}, namelly, that of binary trees
with |Bin| and |Leaf|. Next we explore this notion of patches
for arbitrary term algebras and, in the remainder of the section,
discuss a composition and inverse notion that gives rise to
a grupoid structure.

  Because we need the notion of variable to specify our
deletion and insertion contexts, we will work with the usual
term algebra, but augmented with a countable set $V$ of variables.
That is, let $L$ be a language, we denote by $\termsof{L}$ the set of
terms over $L$ augmented with the set $V$ of variables. For
any $t \in \termsof{L}$, $\vars{t} \subseteq V$ denotes the
variables in $t$. When $\vars{t} = \emptyset$, we say $t$
is a \emph{term}.

\begin{mydef}[Patch]
  Let $L$ be a language, a patch |p| consists in any element of
$\termsof{L} \times \termsof{L}$ such that |vars (pins p) sub (vars
(pdel p))|, where |pdel p| and |pins p| ared |pins p| and second are
the first and second projections, respectivelly.
Given two elements |d , i| of $\termsof{L}$, we denote a patch
as |patch d i|.
\end{mydef}

  As usual when working with binders and variables, we assume that
variable name clashes between two patches. Application of a patch to a
term is easily defined with the help of unification.  Take the |swap|
patch, |patch (Bin x y) (Bin y x)|, and the tern |t = Bin Leaf (Bin Leaf
Leaf)|. First we must unify the deletion context wiht |t|, which
yields the substitution |x = Leaf && y = Bin Leaf Leaf|. To get
the result, we must apply this substitution to the insertion context
of our patch. 

\begin{mydef}[Application] 
  Let $p$ be a patch over $\termsof{L}$ and $t$ a term over $\termsof{L}$,
we say |p| applies to |t| whenever |pdel p| unifies with |t|. 
Let |alpha| be such substitution, the result of the application is 
|alpha (pins p)|. We define the relation |app p t u| to captures exactly that.
\begin{code}
app p t u #= exists alpha dot (unifs alpha (pdel p) t) && alpha (pins p) == u
\end{code}
We often abuse notation and write |app p t = u| instead of |app p t u|.
\end{mydef}
 
\begin{lemma}
For all patch |p, t| and |u|, if |app p t = u|, then
|u| is a term, that is, |vars u == emptyset|.
\end{lemma}
\begin{proof}
  Let |alpha| be the witness of |app p t u|, we
know |u == alpha (pins p)|. We must prove that |alpha|
substitutes all variables in |pins p| for terms to conclude the proof.
That is simple considering that |unifs alpha (pdel p) t|, 
|vars t == emptyset| and |vars (pins p) sub (vars (pdel p))|.
\end{proof}

  With a notion of application at hand, we can define an extensional
equality for our patches. We say patches $p$ and $q$ are equal,
denoted |p ~ q|, whenever |(app p t u) iff (app q t u)|, for all |t,
u|. It is easy to prove this gives rise to an equivalence
relation. Moreover, it correctly identifies patches equal up to
renaming of variables.

  The next step in constructing an algebra of patches, is to study
the composition of patches. \victor{hint at optimality problems?}
Given patches $p$ and $q$, however, they are not always composable.
Take |p = patch (Bin x y) (Bin y x)| and |q = patch Leaf (Bin Leaf Leaf)|,
|after p q| is defined as |patch Leaf Leaf|, but |after q p| cannot be defined:
the result of |p| has a |Bin| at its head where |q| expects a |Leaf|.

\begin{mydef}[Composition]
Let |p| and |q| be patches, we say |p| composes with |q|,
denoted |comp p q|, whenever |pdel p| is unifiable with |pins q|.
Assume |comp p q| and let |sigma| be the substituion witnessing
the unification above. We define |after p q| as:

\begin{code}
after p q #= patch (sigma (pdel q)) (sigma (pins p))
\end{code}
\end{mydef}

\begin{lemma}
  Let |p| and |q| be patches such that |comp p q|. Then,
for all |t, u|, |app (after p q) t = u| if and only if |app q t = w &&
app p w = u|, for some |w|. 
\end{lemma}
\begin{proof}
todo: transcribe from notebook
\end{proof}

\begin{lemma}
For any patch $p$, the identity patch |patch x x| is a left and right
identity to patch composition, that is, |after p (patch x x) ~ p| and
|after (patch x x) p ~ p|.
\end{lemma}
\begin{proof}
trivial
\end{proof}

  Before tackling associativity of composition, we must prove
two auxiliary lemmas, below.

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

  Finally, we can prove the associativity of our composition operation.
  
\begin{lemma}
Let $p$ and $q$ be composable patches. Let $r$ be a patch composable
with |after p q|. Then, $q$ and $r$ are composable and $p$ and |after q r|
are composable. Moreover, |after ((after p q)) r ~ after p ((after r q))|
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

\subsection{The Case Against Inverses}

\victor{Mimram dislikes inverses in the theory, they remove the
ability to use model merges through pushouts}

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
