module

public import Mathlib.Algebra.Ring.Parity
public import Mathlib.Topology.UniformSpace.Defs
public import PiBaseLean.AdditionalDefs.Cover

import Mathlib.Topology.Homeomorph.Lemmas

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
def List.ofFun {α : Type u} (f : ℕ → α) : ℕ → List α
  | 0 => []
  | .succ n => .ofFun f n ++ [f n]

@[simp]
theorem List.ofFun_length {α : Type u} (f : ℕ → α) (n : ℕ) :
    (List.ofFun f n).length = n := by
  induction n with
   | zero => rfl
   | succ n ih =>
    rw [List.ofFun]
    simpa

def List.ltakeHalf {α : Type u} : List α → ℕ → List α
    | _, 0 => []
    | [], _ + 1 => []
    | [a], _ + 1 => [a]
    | a :: _ :: l, n + 1 => a :: ltakeHalf l n

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
  ∀ b : ℕ → X, (∀ n, b (2 * n + 1) = f n ((List.ofFun b (2 * n + 1)).rtakeHalf k)) →
    ¬ IsPayoff G b

def HasWinningStrategyA : Prop :=
  ∃ f : List X → X, WinningStrategyA G f

/-- We say Player A has a k-Markov winning strategy, if they have a winning strategy only depending
on the round number and the k most recent moves by the opponent. -/
def HasMarkovKWinningStrategyA (k : ℕ) : Prop :=
  ∃ f : ℕ → List X → X, MarkovKWinningStrategyA G f k

def HasWinningStrategyB : Prop :=
  ∃ f : List X → X, WinningStrategyB G f

/-- We say Player B has a k-Markov winning strategy, if they have a winning strategy only depending
on the round number and the k most recent moves by the opponent. -/
def HasMarkovKWinningStrategyB (k : ℕ) : Prop :=
  ∃ f : ℕ → List X → X, MarkovKWinningStrategyB G f k

def MarkovKStrategy.toStrategy (f : ℕ → List X → X) (k : ℕ) : List X → X :=
  fun l ↦ f (l.length / 2) (l.rtakeHalf k)

theorem MarkovKWinningStrategyA.winningStrategyA
    {f : ℕ → List X → X} {k : ℕ}
    (hf : MarkovKWinningStrategyA G f k) :
    WinningStrategyA G (MarkovKStrategy.toStrategy f k) := by
  intro _ h
  apply hf
  simp [h, MarkovKStrategy.toStrategy]

theorem HasMarkovKWinningStrategyA.hasWinningStrategyA {k : ℕ}
    (h : HasMarkovKWinningStrategyA G k) :
    HasWinningStrategyA G :=
  let ⟨f, hf⟩ := h
  ⟨MarkovKStrategy.toStrategy f k, MarkovKWinningStrategyA.winningStrategyA G hf⟩

theorem MarkovKWinningStrategyA.winningStrategyB
    {f : ℕ → List X → X} {k : ℕ}
    (hf : MarkovKWinningStrategyB G f k) :
    WinningStrategyB G (MarkovKStrategy.toStrategy f k) := by
  intro _ h
  apply hf
  simp only [h, MarkovKStrategy.toStrategy, List.ofFun_length]
  grind

theorem HasMarkovKWinningStrategyB.hasWinningStrategyB {k : ℕ}
    (h : HasMarkovKWinningStrategyB G k) :
    HasWinningStrategyB G :=
  let ⟨f, hf⟩ := h
  ⟨MarkovKStrategy.toStrategy f k, MarkovKWinningStrategyA.winningStrategyB G hf⟩

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
      (Even l.length → ∃ a, l.getLastD ∅ = {a} ∧ a ∈ l.dropLast.getLastD ∅)))

/- general Gfin selection game See https://www.sciencedirect.com/science/article/pii/S016686411830470X -/
def gFinGame {X : Type u} (A B : Set (Set X)) : Game (Set X) :=
  Game.ofAllowed (Game.mk (fun a ↦ ⋃ n, a (2 * n + 1) ∉ B))
    (fun l ↦ l ≠ [] → ((Odd l.length → l.getLastD ∅ ∈ A) ∧
      (Even l.length → (l.getLastD ∅).Finite ∧ l.getLastD ∅ ⊆ l.dropLast.getLastD ∅)))

/-- See https://www.sciencedirect.com/science/article/pii/S016686411830470X -/
def rothbergerGame (X : Type u) [TopologicalSpace X] : Game (Set (Set X)) :=
  g1Game {A : Set (Set X) | sUnion A = univ ∧ ∀ s ∈ A, IsOpen s}
    {A : Set (Set X) | sUnion A = univ ∧ ∀ s ∈ A, IsOpen s}

/-- See https://www.sciencedirect.com/science/article/pii/S016686411830470X -/
def mengerGame (X : Type u) [TopologicalSpace X] : Game (Set (Set X)) :=
  gFinGame {A : Set (Set X) | sUnion A = univ ∧ ∀ s ∈ A, IsOpen s}
    {A : Set (Set X) | sUnion A = univ ∧ ∀ s ∈ A, IsOpen s}

/-- See https://www.sciencedirect.com/science/article/pii/S0166864121001863 -/
def kMengerGame (X : Type u) [TopologicalSpace X] : Game (Set (Set X)) :=
  gFinGame {A : Set (Set X) | IsKCover' A} {A : Set (Set X) | IsKCover' A}

/-- See https://www.sciencedirect.com/science/article/pii/S0166864121001863 -/
def kRothbergerGame (X : Type u) [TopologicalSpace X] : Game (Set (Set X)) :=
  g1Game {A : Set (Set X) | IsKCover' A} {A : Set (Set X) | IsKCover' A}

/-- See https://topology.pi-base.org/properties/P187 -/
def wGame {X : Type u} [TopologicalSpace X] (x : X) : Game (X × Set X) :=
  Game.ofAllowed (Game.mk (fun a ↦ Tendsto (fun n ↦ (a (2 * n + 1)).1) atTop (𝓝 x)))
    (fun l ↦ l ≠ [] → (Odd l.length → (l.getLastD (x, ∅)).2 ∈ 𝓝 x) ∧
      (Even l.length → (l.getLastD (x, ∅)).1 ∈ (l.dropLast.getLastD (x, ∅)).2))

/-- See https://topology.pi-base.org/properties/P206 -/
def strongChoquetGame (X : Type u) [TopologicalSpace X] [Inhabited X] : Game (X × Set X) :=
  Game.ofAllowed (Game.mk fun a ↦ ⋂ n, (a n).2 = ∅) fun l ↦ IsOpen (l.getLastD (default, univ)).2 ∧
    (l.getLastD (default, univ)).2 ⊆ (l.dropLast.getLastD (default, univ)).2 ∧
      (Odd l.length → (l.getLastD (default, univ)).1 ∈ (l.getLastD (default, univ)).2) ∧
      (Even l.length → (l.dropLast.getLastD (default, univ)).1 ∈ (l.getLastD (default, univ)).2)

/-- The proximal game. The condition `Inhabited X` is an implementation detail; in theory it could
also be played on the empty space, but that makes the lean definition much uglier. -/
def proximalGame (X : Type u) [UniformSpace X] [Inhabited X] : Game (X × Set (X × X)) :=
    Game.ofAllowed (Game.mk fun a ↦ (∃ z, Tendsto (fun n ↦ (a n).1) atTop (𝓝 z)) ∨
        ⋂ n, Prod.mk (a (2 * n + 1)).1 ⁻¹' (a (2 * n + 1)).2 = ∅)
      fun l ↦ l ≠ [] →
        (Odd l.length → (l.getLastD (default, univ)).2 ∈ uniformity X ∧
          (l.getLastD (default, univ)).2 ⊆ (l.dropLast.getLastD (default, univ)).2 ∧
            (l.getLastD (default, univ)).1 = (l.dropLast.getLastD (default, univ)).1) ∧
            (Even l.length → (l.length > 2 → (l.getLastD (default, univ)).1 ∈ Prod.mk
              (l.dropLast.getLastD (default, univ)).1 ⁻¹'
                ((l.dropLast.dropLast.getLastD (default, univ)).2)) ∧
                (l.getLastD (default, univ)).2 = (l.dropLast.getLastD (default, univ)).2)

end

section AIGenerated

/- Transporting games along a relabelling of the moves -/

section Transport

variable {A : Type u} {B : Type v}

theorem map_ofFun (e : B → A) (b : ℕ → B) (k : ℕ) :
    (List.ofFun b k).map e = List.ofFun (fun n ↦ e (b n)) k := by
  induction k with
  | zero => rfl
  | succ k ih => simp [List.ofFun, ih]

theorem map_ltakeHalf (e : B → A) (l : List B) (n : ℕ) :
    (l.ltakeHalf n).map e = (l.map e).ltakeHalf n := by
  induction n generalizing l with
  | zero =>
    match l with
    | [] => rfl
    | [_] => rfl
    | _ :: _ :: _ => rfl
  | succ n ih =>
    match l with
    | [] => rfl
    | [_] => rfl
    | _ :: _ :: l => exact congrArg _ (ih l)

theorem map_rtakeHalf (e : B → A) (l : List B) (n : ℕ) :
    (l.rtakeHalf n).map e = (l.map e).rtakeHalf n := by
  change (l.reverse.ltakeHalf n).map e = (l.map e).reverse.ltakeHalf n
  rw [map_ltakeHalf, List.map_reverse]

/-- Transport of a payoff condition through a relabelling `e` of the moves, for games built
with `Game.ofAllowed`. -/
theorem isPayoff_ofAllowed_iff {G : Game A} {H : Game B} {SA : AllowedMoves A}
    {SB : AllowedMoves B} (e : B → A) (hS : ∀ l : List B, SB l ↔ SA (l.map e)) (b : ℕ → B)
    (hP : H.IsPayoff b ↔ G.IsPayoff fun n ↦ e (b n)) :
    (H.ofAllowed SB).IsPayoff b ↔ (G.ofAllowed SA).IsPayoff fun n ↦ e (b n) := by
  have hSk : ∀ k : ℕ, SB (List.ofFun b k) ↔ SA (List.ofFun (fun n ↦ e (b n)) k) := by
    intro k
    rw [hS, map_ofFun]
  simp only [Game.ofAllowed, hSk, hP]

/-- Transport a winning strategy for player `A` along an equivalence of moves. -/
theorem HasWinningStrategyA.of_equiv {G : Game A} {H : Game B} (e : B ≃ A)
    (hP : ∀ b : ℕ → B, (G.IsPayoff fun n ↦ e (b n)) → H.IsPayoff b)
    (hG : HasWinningStrategyA G) : HasWinningStrategyA H := by
  obtain ⟨f, hf⟩ := hG
  refine ⟨fun l ↦ e.symm (f (l.map e)), ?_⟩
  intro b hb
  refine hP b (hf (fun n ↦ e (b n)) ?_)
  intro n
  show e (b (2 * n)) = f (List.ofFun (fun n ↦ e (b n)) (2 * n))
  rw [← map_ofFun]
  simpa using congrArg e (hb n)

/-- Transport a winning strategy for player `B` along an equivalence of moves. -/
theorem HasWinningStrategyB.of_equiv {G : Game A} {H : Game B} (e : B ≃ A)
    (hP : ∀ b : ℕ → B, H.IsPayoff b → G.IsPayoff fun n ↦ e (b n))
    (hG : HasWinningStrategyB G) : HasWinningStrategyB H := by
  obtain ⟨f, hf⟩ := hG
  refine ⟨fun l ↦ e.symm (f (l.map e)), ?_⟩
  intro b hb hpb
  refine hf (fun n ↦ e (b n)) ?_ (hP b hpb)
  intro n
  show e (b (2 * n + 1)) = f (List.ofFun (fun n ↦ e (b n)) (2 * n + 1))
  rw [← map_ofFun]
  simpa using congrArg e (hb n)

/-- The `k`-Markov analogue of `HasWinningStrategyB.of_equiv`. -/
theorem HasMarkovKWinningStrategyB.of_equiv {G : Game A} {H : Game B} {k : ℕ} (e : B ≃ A)
    (hP : ∀ b : ℕ → B, H.IsPayoff b → G.IsPayoff fun n ↦ e (b n))
    (hG : HasMarkovKWinningStrategyB G k) : HasMarkovKWinningStrategyB H k := by
  obtain ⟨f, hf⟩ := hG
  refine ⟨fun n l ↦ e.symm (f n (l.map e)), ?_⟩
  intro b hb hpb
  refine hf (fun n ↦ e (b n)) ?_ (hP b hpb)
  intro n
  show e (b (2 * n + 1)) = f n ((List.ofFun (fun n ↦ e (b n)) (2 * n + 1)).rtakeHalf k)
  rw [← map_ofFun, ← map_rtakeHalf]
  simpa using congrArg e (hb n)

end Transport

/- Transporting families of moves -/

section FamilyTransport

variable {V : Type u} {W : Type v} (e : V ≃ W)

theorem familyEquiv_apply (S : Set V) : Equiv.Set.congr e S = e '' S := rfl

theorem familyEquiv_symm_apply (T : Set W) : (Equiv.Set.congr e).symm T = e.symm '' T := rfl

@[simp]
theorem familyEquiv_empty : Equiv.Set.congr e ∅ = (∅ : Set W) := image_empty _

theorem familyEquiv_mem_iff {S : Set V} {a : V} : e a ∈ Equiv.Set.congr e S ↔ a ∈ S := by
  rw [familyEquiv_apply]
  exact e.injective.mem_set_image

theorem familyEquiv_singleton (a : V) : Equiv.Set.congr e {a} = {e a} := image_singleton

theorem familyEquiv_iUnion (s : ℕ → Set V) :
    Equiv.Set.congr e (⋃ n, s n) = ⋃ n, Equiv.Set.congr e (s n) := by
  simp only [familyEquiv_apply, image_iUnion]

@[simp]
theorem familyEquiv_finite (S : Set V) : (Equiv.Set.congr e S).Finite ↔ S.Finite := by
  rw [familyEquiv_apply]
  refine ⟨fun h ↦ ?_, fun h ↦ h.image _⟩
  have := h.image e.symm
  rwa [e.symm_image_image] at this

@[simp]
theorem familyEquiv_subset (S T : Set V) :
    Equiv.Set.congr e S ⊆ Equiv.Set.congr e T ↔ S ⊆ T := by
  rw [familyEquiv_apply, familyEquiv_apply]
  exact image_subset_image_iff e.injective

theorem familyEquiv_exists_singleton (S T : Set V) :
    (∃ a, Equiv.Set.congr e S = {a} ∧ a ∈ Equiv.Set.congr e T) ↔
      (∃ a, S = {a} ∧ a ∈ T) := by
  constructor
  · rintro ⟨a, hS, ha⟩
    refine ⟨e.symm a, ?_, ?_⟩
    · have : (Equiv.Set.congr e).symm (Equiv.Set.congr e S) = (Equiv.Set.congr e).symm {a} :=
        congrArg _ hS
      rwa [Equiv.symm_apply_apply, familyEquiv_symm_apply, image_singleton] at this
    · rw [← familyEquiv_mem_iff e, Equiv.apply_symm_apply]
      exact ha
  · rintro ⟨a, rfl, ha⟩
    exact ⟨e a, familyEquiv_singleton e a, familyEquiv_mem_iff e |>.mpr ha⟩

/-- The allowed moves of a `g1Game`. -/
def g1Allowed {V : Type*} (A : Set (Set V)) : AllowedMoves (Set V) :=
  fun l ↦ l ≠ [] → ((Odd l.length → l.getLastD ∅ ∈ A) ∧
    (Even l.length → ∃ a, l.getLastD ∅ = {a} ∧ a ∈ l.dropLast.getLastD ∅))

/-- The allowed moves of a `gFinGame`. -/
def gFinAllowed {V : Type*} (A : Set (Set V)) : AllowedMoves (Set V) :=
  fun l ↦ l ≠ [] → ((Odd l.length → l.getLastD ∅ ∈ A) ∧
    (Even l.length → (l.getLastD ∅).Finite ∧ l.getLastD ∅ ⊆ l.dropLast.getLastD ∅))

variable {A : Set (Set V)} {A' : Set (Set W)}

private theorem familyEquiv_getLastD (l : List (Set V)) :
    (l.map (Equiv.Set.congr e)).getLastD ∅ = Equiv.Set.congr e (l.getLastD ∅) := by
  rw [← familyEquiv_empty e, List.getLastD_map]

private theorem familyEquiv_getLastD_dropLast (l : List (Set V)) :
    (l.map (Equiv.Set.congr e)).dropLast.getLastD ∅
      = Equiv.Set.congr e (l.dropLast.getLastD ∅) := by
  rw [← List.map_dropLast, familyEquiv_getLastD]

theorem g1Allowed_iff (hA : ∀ S : Set V, Equiv.Set.congr e S ∈ A' ↔ S ∈ A) (l : List (Set V)) :
    g1Allowed A l ↔ g1Allowed A' (l.map (Equiv.Set.congr e)) := by
  simp only [g1Allowed, familyEquiv_getLastD e, familyEquiv_getLastD_dropLast e, List.length_map,
    ne_eq, List.map_eq_nil_iff, hA, familyEquiv_exists_singleton e]

theorem gFinAllowed_iff (hA : ∀ S : Set V, Equiv.Set.congr e S ∈ A' ↔ S ∈ A)
    (l : List (Set V)) :
    gFinAllowed A l ↔ gFinAllowed A' (l.map (Equiv.Set.congr e)) := by
  simp only [gFinAllowed, familyEquiv_getLastD e, familyEquiv_getLastD_dropLast e,
    List.length_map, ne_eq, List.map_eq_nil_iff, hA, familyEquiv_finite, familyEquiv_subset]

variable {B : Set (Set V)} {B' : Set (Set W)}

theorem selectionPayoff_iff (hB : ∀ S : Set V, Equiv.Set.congr e S ∈ B' ↔ S ∈ B)
    (b : ℕ → Set V) :
    ((⋃ n, b (2 * n + 1)) ∉ B) ↔ ((⋃ n, Equiv.Set.congr e (b (2 * n + 1))) ∉ B') := by
  rw [← familyEquiv_iUnion, hB]

theorem g1Game_isPayoff_iff (hA : ∀ S : Set V, Equiv.Set.congr e S ∈ A' ↔ S ∈ A)
    (hB : ∀ S : Set V, Equiv.Set.congr e S ∈ B' ↔ S ∈ B) (b : ℕ → Set V) :
    (g1Game A B).IsPayoff b ↔ (g1Game A' B').IsPayoff fun n ↦ Equiv.Set.congr e (b n) :=
  isPayoff_ofAllowed_iff (Equiv.Set.congr e) (g1Allowed_iff e hA) b (selectionPayoff_iff e hB b)

theorem gFinGame_isPayoff_iff (hA : ∀ S : Set V, Equiv.Set.congr e S ∈ A' ↔ S ∈ A)
    (hB : ∀ S : Set V, Equiv.Set.congr e S ∈ B' ↔ S ∈ B) (b : ℕ → Set V) :
    (gFinGame A B).IsPayoff b ↔ (gFinGame A' B').IsPayoff fun n ↦ Equiv.Set.congr e (b n) :=
  isPayoff_ofAllowed_iff (Equiv.Set.congr e) (gFinAllowed_iff e hA) b (selectionPayoff_iff e hB b)

end FamilyTransport

/-! ### Transporting topological move families -/

section CoverTransport

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

/-- Taking preimages under a homeomorphism is a bijection between subsets. -/
def preimageSetEquiv (φ : X ≃ₜ Y) : Set Y ≃ Set X where
  toFun t := φ ⁻¹' t
  invFun s := φ.symm ⁻¹' s
  left_inv t := by ext y; simp
  right_inv s := by ext x; simp

@[simp]
theorem preimageSetEquiv_apply (φ : X ≃ₜ Y) (t : Set Y) : preimageSetEquiv φ t = φ ⁻¹' t := rfl

/-- Taking preimages under a homeomorphism is a bijection between families of subsets. -/
def preimageFamilyEquiv (φ : X ≃ₜ Y) : Set (Set Y) ≃ Set (Set X) :=
  Equiv.Set.congr (preimageSetEquiv φ)

theorem preimageFamilyEquiv_apply (φ : X ≃ₜ Y) (S : Set (Set Y)) :
    preimageFamilyEquiv φ S = (preimageSetEquiv φ) '' S := rfl

@[simp]
theorem preimageFamilyEquiv_empty (φ : X ≃ₜ Y) :
    preimageFamilyEquiv φ ∅ = (∅ : Set (Set X)) := by
  rw [preimageFamilyEquiv_apply, image_empty]

theorem sUnion_preimageFamilyEquiv (φ : X ≃ₜ Y) (S : Set (Set Y)) :
    ⋃₀ (preimageFamilyEquiv φ S) = φ ⁻¹' (⋃₀ S) := by
  rw [preimageFamilyEquiv_apply, sUnion_image, preimage_sUnion]
  simp

theorem preimageFamilyEquiv_iUnion (φ : X ≃ₜ Y) (s : ℕ → Set (Set Y)) :
    preimageFamilyEquiv φ (⋃ n, s n) = ⋃ n, preimageFamilyEquiv φ (s n) := by
  simp only [preimageFamilyEquiv_apply, image_iUnion]

@[simp]
theorem preimageFamilyEquiv_finite (φ : X ≃ₜ Y) (S : Set (Set Y)) :
    (preimageFamilyEquiv φ S).Finite ↔ S.Finite := by
  rw [preimageFamilyEquiv_apply]
  refine ⟨fun h ↦ ?_, fun h ↦ h.image _⟩
  have := h.image (preimageSetEquiv φ).symm
  rwa [(preimageSetEquiv φ).symm_image_image] at this

@[simp]
theorem preimageFamilyEquiv_subset (φ : X ≃ₜ Y) (S T : Set (Set Y)) :
    preimageFamilyEquiv φ S ⊆ preimageFamilyEquiv φ T ↔ S ⊆ T := by
  rw [preimageFamilyEquiv_apply, preimageFamilyEquiv_apply]
  exact image_subset_image_iff (preimageSetEquiv φ).injective

theorem preimage_eq_univ_iff_of_homeomorph (φ : X ≃ₜ Y) (U : Set Y) :
    φ ⁻¹' U = univ ↔ U = univ := by
  rw [preimage_eq_univ_iff, φ.surjective.range_eq, univ_subset_iff]

@[simp]
theorem preimageFamilyEquiv_mem_openCovers (φ : X ≃ₜ Y) (S : Set (Set Y)) :
    (⋃₀ (preimageFamilyEquiv φ S) = univ ∧ ∀ s ∈ preimageFamilyEquiv φ S, IsOpen s) ↔
      (⋃₀ S = univ ∧ ∀ t ∈ S, IsOpen t) := by
  rw [sUnion_preimageFamilyEquiv, preimage_eq_univ_iff_of_homeomorph]
  refine and_congr_right fun _ ↦ ⟨fun h t ht ↦ ?_, fun h s hs ↦ ?_⟩
  · exact φ.isOpen_preimage.mp (h (φ ⁻¹' t) ⟨t, ht, rfl⟩)
  · obtain ⟨t, ht, rfl⟩ := hs
    exact φ.isOpen_preimage.mpr (h t ht)

theorem preimageFamilyEquiv_eq (φ : X ≃ₜ Y) :
    preimageFamilyEquiv φ = Equiv.Set.congr (preimageSetEquiv φ) := rfl

theorem preimageFamilyEquiv_mem_openCovers' (φ : X ≃ₜ Y) (S : Set (Set Y)) :
    preimageFamilyEquiv φ S ∈ {A : Set (Set X) | ⋃₀ A = univ ∧ ∀ s ∈ A, IsOpen s} ↔
      S ∈ {A : Set (Set Y) | ⋃₀ A = univ ∧ ∀ s ∈ A, IsOpen s} :=
  preimageFamilyEquiv_mem_openCovers φ S

theorem preimageFamilyEquiv_univ_mem_iff (φ : X ≃ₜ Y) (S : Set (Set Y)) :
    (univ : Set X) ∈ preimageFamilyEquiv φ S ↔ (univ : Set Y) ∈ S := by
  rw [preimageFamilyEquiv_apply]
  constructor
  · rintro ⟨t, ht, hteq⟩
    rw [preimageSetEquiv_apply] at hteq
    rwa [← (preimage_eq_univ_iff_of_homeomorph φ t).mp hteq]
  · intro hS
    exact ⟨univ, hS, by simp [preimageSetEquiv_apply]⟩

theorem preimageFamilyEquiv_isKCover' (φ : X ≃ₜ Y) (S : Set (Set Y)) :
    IsKCover' (preimageFamilyEquiv φ S) ↔ IsKCover' S := by
  have hcover := preimageFamilyEquiv_mem_openCovers φ S
  have hKrange : ∀ K : Set Y, K ⊆ range φ := fun K ↦ by
    rw [φ.surjective.range_eq]
    exact subset_univ K
  constructor
  · rintro ⟨hopen, hunion, hne, hK⟩
    obtain ⟨hunion', hopen'⟩ := hcover.mp ⟨hunion, hopen⟩
    refine ⟨hopen', hunion', fun h ↦ hne ((preimageFamilyEquiv_univ_mem_iff φ S).mpr h), ?_⟩
    intro K hKc
    obtain ⟨i, hi, hKi⟩ := hK (φ.isCompact_preimage.mpr hKc)
    rw [preimageFamilyEquiv_apply] at hi
    obtain ⟨t, ht, rfl⟩ := hi
    rw [preimageSetEquiv_apply] at hKi
    exact ⟨t, ht, (preimage_subset_preimage_iff (hKrange K)).mp hKi⟩
  · rintro ⟨hopen, hunion, hne, hK⟩
    obtain ⟨hunion', hopen'⟩ := hcover.mpr ⟨hunion, hopen⟩
    refine ⟨hopen', hunion', fun h ↦ hne ((preimageFamilyEquiv_univ_mem_iff φ S).mp h), ?_⟩
    intro K hKc
    obtain ⟨t, ht, hKt⟩ := hK (hKc.image φ.continuous)
    refine ⟨preimageSetEquiv φ t, ⟨t, ht, rfl⟩, ?_⟩
    rw [preimageSetEquiv_apply]
    exact fun x hx ↦ hKt ⟨x, hx, rfl⟩

end CoverTransport

/- Transporting the Menger game -/

section MengerTransport

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

/-- The set of allowed moves of `mengerGame`. -/
private def openCoverAllowed (Z : Type*) [TopologicalSpace Z] : AllowedMoves (Set (Set Z)) :=
  fun l ↦ l ≠ [] → ((Odd l.length →
      l.getLastD ∅ ∈ {A : Set (Set Z) | ⋃₀ A = univ ∧ ∀ s ∈ A, IsOpen s}) ∧
    (Even l.length → (l.getLastD ∅).Finite ∧ l.getLastD ∅ ⊆ l.dropLast.getLastD ∅))

private theorem openCoverAllowed_iff (φ : X ≃ₜ Y) (l : List (Set (Set Y))) :
    openCoverAllowed Y l ↔ openCoverAllowed X (l.map (preimageFamilyEquiv φ)) := by
  have hLast : (l.map (preimageFamilyEquiv φ)).getLastD ∅
      = preimageFamilyEquiv φ (l.getLastD ∅) := by
    rw [← preimageFamilyEquiv_empty φ, List.getLastD_map]
  have hLast' : (l.map (preimageFamilyEquiv φ)).dropLast.getLastD ∅
      = preimageFamilyEquiv φ (l.dropLast.getLastD ∅) := by
    rw [← List.map_dropLast, ← preimageFamilyEquiv_empty φ, List.getLastD_map]
  simp only [openCoverAllowed, hLast, hLast', List.length_map, ne_eq, List.map_eq_nil_iff,
    mem_ofPred_eq, preimageFamilyEquiv_mem_openCovers, preimageFamilyEquiv_finite,
    preimageFamilyEquiv_subset]

/-- The payoff conditions of the Menger games correspond under a homeomorphism. -/
theorem mengerGame_isPayoff_iff (φ : X ≃ₜ Y) (b : ℕ → Set (Set Y)) :
    (mengerGame Y).IsPayoff b ↔
      (mengerGame X).IsPayoff fun n ↦ preimageFamilyEquiv φ (b n) := by
  refine isPayoff_ofAllowed_iff (preimageFamilyEquiv φ) (openCoverAllowed_iff φ) b ?_
  change (⋃ n, b (2 * n + 1)) ∉ {A : Set (Set Y) | ⋃₀ A = univ ∧ ∀ s ∈ A, IsOpen s} ↔
    (⋃ n, preimageFamilyEquiv φ (b (2 * n + 1))) ∉
      {A : Set (Set X) | ⋃₀ A = univ ∧ ∀ s ∈ A, IsOpen s}
  rw [← preimageFamilyEquiv_iUnion]
  simp

theorem HasWinningStrategyB.mengerGame_of_homeomorph (φ : X ≃ₜ Y)
    (h : HasWinningStrategyB (mengerGame X)) : HasWinningStrategyB (mengerGame Y) :=
  h.of_equiv (preimageFamilyEquiv φ) fun b hb ↦ (mengerGame_isPayoff_iff φ b).mp hb

theorem HasMarkovKWinningStrategyB.mengerGame_of_homeomorph {k : ℕ} (φ : X ≃ₜ Y)
    (h : HasMarkovKWinningStrategyB (mengerGame X) k) :
    HasMarkovKWinningStrategyB (mengerGame Y) k :=
  h.of_equiv (preimageFamilyEquiv φ) fun b hb ↦ (mengerGame_isPayoff_iff φ b).mp hb

end MengerTransport

/- Generic proximal-game transport helpers -/

section ProximalTransport

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

@[simp]
theorem prodMap_symm_prodMap (φ : X ≃ₜ Y) (p : X × X) :
    Prod.map (φ.symm : Y → X) φ.symm (Prod.map (φ : X → Y) φ p) = p := by
  obtain ⟨x₁, x₂⟩ := p
  simp

@[simp]
theorem prodMap_prodMap_symm (φ : X ≃ₜ Y) (p : Y × Y) :
    Prod.map (φ : X → Y) φ (Prod.map (φ.symm : Y → X) φ.symm p) = p := by
  obtain ⟨y₁, y₂⟩ := p
  simp

def preimageRelEquiv (φ : X ≃ₜ Y) : Set (Y × Y) ≃ Set (X × X) where
  toFun V := Prod.map φ φ ⁻¹' V
  invFun U := Prod.map φ.symm φ.symm ⁻¹' U
  left_inv V := by ext p; simp
  right_inv U := by ext p; simp

@[simp]
theorem preimageRelEquiv_apply (φ : X ≃ₜ Y) (V : Set (Y × Y)) :
    preimageRelEquiv φ V = Prod.map φ φ ⁻¹' V := rfl

def proximalMoveEquiv (φ : X ≃ₜ Y) : Y × Set (Y × Y) ≃ X × Set (X × X) :=
  (φ.symm.toEquiv).prodCongr (preimageRelEquiv φ)

@[simp]
theorem proximalMoveEquiv_fst (φ : X ≃ₜ Y) (p : Y × Set (Y × Y)) :
    (proximalMoveEquiv φ p).1 = φ.symm p.1 := rfl

@[simp]
theorem proximalMoveEquiv_snd (φ : X ≃ₜ Y) (p : Y × Set (Y × Y)) :
    (proximalMoveEquiv φ p).2 = Prod.map φ φ ⁻¹' p.2 := rfl

theorem prodMap_surjective (φ : X ≃ₜ Y) : Function.Surjective (Prod.map (φ : X → Y) φ) :=
  fun p ↦ ⟨Prod.map φ.symm φ.symm p, prodMap_prodMap_symm φ p⟩

@[simp]
theorem preimage_prodMap_subset_iff (φ : X ≃ₜ Y) (V W : Set (Y × Y)) :
    Prod.map φ φ ⁻¹' V ⊆ Prod.map φ φ ⁻¹' W ↔ V ⊆ W :=
  preimage_subset_preimage_iff (by rw [(prodMap_surjective φ).range_eq]; exact subset_univ V)

@[simp]
theorem preimage_prodMap_eq_iff (φ : X ≃ₜ Y) (V W : Set (Y × Y)) :
    Prod.map φ φ ⁻¹' V = Prod.map φ φ ⁻¹' W ↔ V = W :=
  preimage_eq_preimage (prodMap_surjective φ)

theorem preimage_eq_empty_iff_of_homeomorph (φ : X ≃ₜ Y) (S : Set Y) :
    φ ⁻¹' S = ∅ ↔ S = ∅ := by
  refine ⟨fun h ↦ ?_, fun h ↦ by rw [h, preimage_empty]⟩
  rw [← image_preimage_eq S φ.surjective, h, image_empty]

theorem slice_preimage_prodMap (φ : X ≃ₜ Y) (y : Y) (V : Set (Y × Y)) :
    Prod.mk (φ.symm y) ⁻¹' (Prod.map φ φ ⁻¹' V) = φ ⁻¹' (Prod.mk y ⁻¹' V) := by
  ext x
  simp

theorem exists_tendsto_comp_iff (φ : X ≃ₜ Y) (f : ℕ → Y) :
    (∃ z : X, Tendsto (fun n ↦ φ.symm (f n)) atTop (𝓝 z)) ↔
      ∃ z : Y, Tendsto f atTop (𝓝 z) := by
  refine ⟨fun ⟨z, hz⟩ ↦ ⟨φ z, ?_⟩,
    fun ⟨z, hz⟩ ↦ ⟨φ.symm z, (φ.symm.continuous.tendsto z).comp hz⟩⟩
  simpa [Function.comp_def] using (φ.continuous.tendsto z).comp hz

end ProximalTransport

end AIGenerated

end PiBase
