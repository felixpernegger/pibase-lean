module

public import Mathlib

@[expose] public section

universe u

/-! This file contains additional general constructions around topological spaces
which are useful for properties and theorems. -/

namespace PiBase

namespace AdditionalDefs

open Set Filter Function Topology

variable {X Y ι : Type*} [TopologicalSpace X] [TopologicalSpace Y]

/-- We call a set `s : Set X` in a topological space *zero*, if there is a continuous function
`f : X → ℝ` such that `f ⁻¹' {0} = s` -/
def IsZero (s : Set X) : Prop :=
  ∃ f : C(X, ℝ), f.toFun ⁻¹' {0} = s

/-- We call a set `s : Set X` in a topological space *cozero*, if there is a continuous function
`f : X → ℝ` such that `f ⁻¹' {0}ᶜ = s` -/
def IsCozero (s : Set X) : Prop :=
  ∃ f : C(X, ℝ), f.toFun ⁻¹' {0}ᶜ = s

/-- A cozero set is open. -/
theorem IsCozero.IsOpen {s : Set X} (hs : IsCozero s) :
    IsOpen s := by
  obtain ⟨f, hf⟩ := hs
  rw [← hf]
  apply Continuous.isOpen_preimage f.continuous_toFun {0}ᶜ
  simp

def IsRelativelyCompact {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∀ {ι : Type u} (U : ι → Set X),
    ∃ t : Finset ι, s ⊆ ⋃ i ∈ t, U i

--TODO: Notation Σ' for this?
/-- Σ-product (of topological spaces).
Not to be confused with the disjoint union (topological sum). -/
def SigmaProduct {Y : ι → Type u} (x : (i : ι) → Y i) : Set ((i : ι) → Y i) :=
  {s : (i : ι) → Y i | {i : ι | s i ≠ x i}.Countable}

/-- A set `s : Set X` is called a *retract*, if there is a continuous map `f : X → s` such that
`∀ x ∈ s, f x = x` -/
def IsRetract {X : Type u} [TopologicalSpace X] (A : Set X) : Prop :=
  ∃ f : C(X, X), f.comp f = f ∧ A = Set.range f

/-- A set is called regular open if it is equal to the interior of its closure. -/
def IsRegularOpen (s : Set X) : Prop :=
  interior (closure s) = s

/-- A regular open set is open -/
theorem IsRegularOpen.IsOpen {s : Set X} (hs : IsRegularOpen s) : IsOpen s := hs ▸ isOpen_interior

--TODO: Better to require `X` connected in this def?
/-- A point *cut point* `p` in a space, is a space such that `X \ {p}` is disconnected. -/
def IsCutPoint (p : X) := ¬ IsPreconnected {p}ᶜ

section Symmetric --TODO: If we get significantly more, make this its own file

/-- A symmetric for of a set. -/
class Symmetric (α : Type u) extends Dist α where
  dist_self (x : α) : dist x x = 0
  dist_comm (x y : α) : dist x y = dist y x
  eq_of_dist_eq_zero : ∀ {x y : α}, dist x y = 0 → x = y

/-- A ball for a symmetric. -/
def Symmetric.ball [Symmetric ι] (i : ι) (ε : ℝ) : Set ι := {x : ι | dist x i ≤ ε}

/-- A semimetric space -/
class SemimetricSpace (X : Type u) [TopologicalSpace X] extends Symmetric X where
  symmetric_nbhd (x : X) : (𝓝 x).HasBasis (fun ε => 0 < ε) (Symmetric.ball x)

/-- A symmetric space -/
class SymmetricSpace (X : Type u) [TopologicalSpace X] extends Symmetric X where
  isOpen_iff (s : Set X) : IsOpen s ↔ ∀ x ∈ s, ∃ ε > 0, Symmetric.ball x ε ⊆ s

end Symmetric

section Path --TODO: If we get significantly more, make this its own file

/-- A set `s : Set X` is called injectively path connected,
if for any two point in `s` there is an injective path in `x` joining them. -/
def IsInjPathConnected (s : Set X) :=
  Pairwise fun x y : X ↦ x ∈ s → y ∈ s → ∃ f : Path x y, Injective f ∧ range f ⊆ s

/-- An injectivley path connected set is path connected. -/
theorem IsInjPathConnected.isPathConnected {s : Set X} (h : IsInjPathConnected s)
    (hs : s.Nonempty) : IsPathConnected s := by
  rw [isPathConnected_iff]
  refine ⟨hs, fun x xs y ys ↦ ?_⟩
  rcases eq_or_ne x y with xy|xy
  · exact xy ▸ JoinedIn.refl xs
  obtain ⟨f, f_inj, fs⟩ := h xy xs ys
  exact ⟨f, fun t ↦ fs (by simp)⟩

/-- A proposition for when the image of the fundamental group at `x : X` under
`f: X → Y` is trivial. -/
def HasTrivialFundGroupImageAt (f : C(X, Y)) (x : X) : Prop :=
  ((FundamentalGroup.map f) x).range = ⊥

end Path

end AdditionalDefs

end PiBase
