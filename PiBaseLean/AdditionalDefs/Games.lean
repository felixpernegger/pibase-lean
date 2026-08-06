module

public import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup
public import Mathlib.Topology.GDelta.MetrizableSpace
public import Mathlib.Topology.Metrizable.Uniformity
public import Mathlib.Algebra.Group.Nat.Even

/-! This file builds up defs and basic theory about Gale-Stewart games. This has been done
previously in Lean, for example here https://afm.episciences.org/17712/pdf

Additionally, we define various topological games.

For a reference on the theory, see https://en.wikipedia.org/wiki/Determinacy

For topological games, see https://en.wikipedia.org/wiki/Topological_game
-/

universe u v

@[expose] public section

open Set Filter Topology

/-- Given some function `f : ℕ → X` and some natural number `n`,
the list of the form `(f(0), f(1), ..., f(n - 1))`. -/
def List.ofFun {X : Type u} (f : ℕ → X) : ℕ → List X
  | 0 => []
  | .succ n => .ofFun f n ++ [f n]

def List.ltakeHalf {α : Type u} : List α → ℕ → List α
    | _, 0 => []
    | [], _ + 1 => []
    | [a], _ + 1 => [a]
    | a :: _ :: l, n + 1 => a :: ltakeHalf l n

def List.init {α : Type u} (l : List α) : List α := l.reverse.tail.reverse

/-- The `n` most recent moves by the opponent in a chronological game history,
listed from newest to oldest. -/
def List.rtakeHalf {α : Type u} (l : List α) (n : ℕ) : List α :=
  ltakeHalf l.reverse n

example : List.ofFun (fun n : ℕ ↦ n) 0 = [] := rfl
example : List.ofFun (fun n : ℕ ↦ n) 1 = [0] := rfl
example : List.ofFun (fun n : ℕ ↦ n) 2 = [0, 1] := rfl
example : List.ofFun (fun n : ℕ ↦ n) 3 = [0, 1, 2] := rfl
example : List.ofFun (fun n : ℕ ↦ n) 4 = [0, 1, 2, 3] := rfl
example : List.ofFun (fun n : ℕ ↦ n) 5 = [0, 1, 2, 3, 4] := rfl

example : List.rtakeHalf ([] : List ℕ) 3 = [] := rfl
example : List.rtakeHalf [0] 3 = [0] := rfl
example : List.rtakeHalf [0, 1] 3 = [1] := rfl
example : List.rtakeHalf [0, 1, 2] 1 = [2] := rfl
example : List.rtakeHalf [0, 1, 2, 3] 2 = [3, 1] := rfl
example : List.rtakeHalf [0, 1, 2, 3, 4] 3 = [4, 2, 0] := rfl

namespace PiBase

/-- A game on some type `X`.
Abstractly, this is equivalent to `Set (ℕ → X)`. -/
structure Game (X : Type u) where
  /-- Whether player A wins on some game. -/
  IsPayoff (a : ℕ → X) : Prop

open Game

variable {X : Type u} (G : Game X)

/-- On a low level, a strategy is just a function `f : List X → X`.
We say a function is a winning strategy for Player `A`, if Player A wins the game
`f([]), a₁, f([a₁]), a₂, ...` is payoff. -/
def WinningStrategyA (f : List X → X) : Prop :=
  ∀ b : ℕ → X, (∀ n, b (2 * n) = f (List.ofFun b (2 * n))) → IsPayoff G b

def MarkovKWinningStrategyA (f : ℕ → List X → X) (k : ℕ) : Prop :=
  ∀ b : ℕ → X, (∀ n, b (2 * n) = f n (List.rtakeHalf (List.ofFun b (2 * n)) k)) →
    IsPayoff G b

/-- A winning strategy for Player B. Note that it is possible neither A nor B have a winning
strategy. -/
def WinningStrategyB (f : List X → X) : Prop :=
  ∀ b : ℕ → X, (∀ n, b (2 * n + 1) = f (List.ofFun b (2 * n + 1))) → ¬ IsPayoff G b

def MarkovKWinningStrategyB (f : ℕ → List X → X) (k : ℕ) : Prop :=
  ∀ b : ℕ → X, (∀ n, b (2 * n + 1) = f n (List.rtakeHalf (List.ofFun b (2 * n + 1)) k)) →
    ¬ IsPayoff G b

def HasWinningStrategyA : Prop :=
  ∃ f : List X → X, WinningStrategyA G f

/-- We say Player A has a k-Markov winning strategy, if they have a winning strategy only depending
on the round number and the k most recent moves by the opponent. -/
def HasMarkovWinningStrategyA (k : ℕ) : Prop :=
  ∃ f : ℕ → List X → X, MarkovKWinningStrategyA G f k

def HasWinningStrategyB : Prop :=
  ∃ f : List X → X, WinningStrategyB G f

/-- We say Player B has a k-Markov winning strategy, if they have a winning strategy only depending
on the round number and the k most recent moves by the opponent. -/
def HasMarkovWinningStrategyB (k : ℕ) : Prop :=
  ∃ f : ℕ → List X → X, MarkovKWinningStrategyB G f k

abbrev AllowedMoves (X : Type u) := List X → Prop

/-- Usually, a game has some "allowed" moves, which the players can do.
If they make a disallowed move, they lose immediately.
This auxiliary definition is meant to formalise this behaviour.

In particle we use this definition to describe the "winning argument" in `G`
and the allowed moves in `S`. -/
def Game.ofAllowed (G : Game X) (S : AllowedMoves X) : Game X where
  IsPayoff a :=
    (∀ n : ℕ, ¬ S (List.ofFun a (2 * n + 1)) → ∃ m < n, ¬ S (List.ofFun a (2 * m + 2))) ∧
      ((∃ n, ¬S (List.ofFun a (2 * n + 2))) ∨ IsPayoff G a)

section

/-- Banach Mazur game. Usually there are conditions on `X` (should be topological space)
and `W` (each member ought to have nonempty interior), but this isn't needed for the definition. -/
def banachMazur (X : Type u) (S : Set X) (W : Set (Set X)) :
    Game (Set X) :=
  Game.ofAllowed (Game.mk (fun s ↦ (S ∩ ⋂ i : ℕ, s i).Nonempty))
    (fun l ↦ (∀ i ∈ l, i ∈ W) ∧ ∀ i ∈ l, l.getLastD ∅ ⊆ i)

/- general G₁ selection game. See https://www.sciencedirect.com/science/article/pii/S016686411830470X -/
def g1Game {X : Type u} (A B : Set (Set X)) : Game (Set X) :=
  Game.ofAllowed (Game.mk (fun a ↦ ⋃ n, a (2 * n + 1) ∉ B))
    (fun l ↦ l ≠ [] → ((Odd l.length → l.getLastD ∅ ∈ A) ∧
      (Even l.length → ∃ a, l.getLastD ∅ = {a} ∧ a ∈ l.init.getLastD ∅)))

/- general Gfin selection game See https://www.sciencedirect.com/science/article/pii/S016686411830470X -/
def gFinGame {X : Type u} (A B : Set (Set X)) : Game (Set X) :=
  Game.ofAllowed (Game.mk (fun a ↦ ⋃ n, a (2 * n + 1) ∉ B))
    (fun l ↦ l ≠ [] → ((Odd l.length → l.getLastD ∅ ∈ A) ∧
      (Even l.length → (l.getLastD ∅).Finite ∧ l.getLastD ∅ ⊆ l.init.getLastD ∅)))

/-- See https://www.sciencedirect.com/science/article/pii/S016686411830470X -/
def rothbergerGame (X : Type u) [TopologicalSpace X] : Game (Set (Set X)) :=
  g1Game {A : Set (Set X) | sUnion A = univ ∧ ∀ s ∈ A, IsOpen s}
    {A : Set (Set X) | sUnion A = univ ∧ ∀ s ∈ A, IsOpen s}

/-- See https://www.sciencedirect.com/science/article/pii/S016686411830470X -/
def mengerGame (X : Type u) [TopologicalSpace X] : Game (Set (Set X)) :=
  gFinGame {A : Set (Set X) | sUnion A = univ ∧ ∀ s ∈ A, IsOpen s}
    {A : Set (Set X) | sUnion A = univ ∧ ∀ s ∈ A, IsOpen s}

/-- See https://topology.pi-base.org/properties/P187 -/
def wGame {X : Type u} [TopologicalSpace X] (x : X) : Game (X × Set X) :=
  Game.ofAllowed (Game.mk (fun a ↦ Tendsto (fun n ↦ (a (2 * n + 1)).1) atTop (𝓝 x)))
    (fun l ↦ l ≠ [] → (Odd l.length → (l.getLastD (x, ∅)).2 ∈ 𝓝 x) ∧
      (Even l.length → (l.getLastD (x, ∅)).1 ∈ (l.init.getLastD (x, ∅)).2))

/-- See https://topology.pi-base.org/properties/P206 -/
def strongChoquetGame (X : Type u) [TopologicalSpace X] (x : X) : Game (X × Set X) :=
  Game.ofAllowed (Game.mk fun a ↦ ⋂ n, (a n).2 = ∅) fun l ↦ IsOpen (l.getLastD (x, univ)).2 ∧
    (l.getLastD (x, univ)).2 ⊆ (l.init.getLastD (x, univ)).2 ∧
      (Odd l.length → (l.getLastD (x, univ)).1 ∈ (l.getLastD (x, univ)).2) ∧
      (Even l.length → (l.init.getLastD (x, univ)).1 ∈ (l.getLastD (x, univ)).2)

/-- The proximal game. The condition `Inhabited X` is an implementation detail; in theory it could
also be played on the empty space, but that makes the lean definition much uglier. -/
def proximalGame (X : Type u) [UniformSpace X] [Inhabited X] : Game (X × Set (X × X)) :=
    Game.ofAllowed (Game.mk fun a ↦ (∃ z, Tendsto (fun n ↦ (a n).1) atTop (𝓝 z)) ∨
        ⋂ n, Prod.mk (a (2 * n + 1)).1 ⁻¹' (a (2 * n + 1)).2 = ∅)
      fun l ↦ l ≠ [] →
        (Odd l.length → (l.getLastD (default, univ)).2 ∈ uniformity X ∧
          (l.getLastD (default, univ)).2 ⊆ (l.init.getLastD (default, univ)).2 ∧
            (l.getLastD (default, univ)).1 = (l.init.getLastD (default, univ)).1) ∧
            (Even l.length → (l.length > 2 → (l.getLastD (default, univ)).1 ∈ Prod.mk
              (l.init.getLastD (default, univ)).1 ⁻¹'
                ((l.init.init.getLastD (default, univ)).2)) ∧
                (l.getLastD (default, univ)).2 = (l.init.getLastD (default, univ)).2)

end

end PiBase
