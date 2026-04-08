module

public import Mathlib.Data.Set.Card
public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import Mathlib.Topology.Path
public import Mathlib.Topology.Connected.PathConnected
public import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup

@[expose] public section

universe u v

/-! This file contains additional definitions which are useful for properties and theorems. -/

namespace Topology

namespace PiBase

namespace AdditionalDefs

open Filter Function Set Topology TopologicalSpace

variable
  {X Y ι ι' α X : Type*} [TopologicalSpace X] [TopologicalSpace Y] {f g : ι → Set X}

def IsInjPathConnected (s : Set X) :=
  Pairwise fun x y : X ↦ x ∈ s → y ∈ s → ∃ f : Path x y, Injective f ∧ range f ⊆ s

theorem IsInjPathConnected.isPathConnected {s : Set X} (h : IsInjPathConnected s)
    (hs : s.Nonempty) : IsPathConnected s := by
  rw [isPathConnected_iff]
  refine ⟨hs, fun x xs y ys ↦ ?_⟩
  rcases eq_or_ne x y with xy|xy
  · exact xy ▸ JoinedIn.refl xs
  obtain ⟨f, f_inj, fs⟩ := h xy xs ys
  exact ⟨f, fun t ↦ fs (by simp)⟩

def PointFinite (U : ι → Set X) :=
  ∀ x : X, { i | x ∈ U i }.Finite

def PointCountable (U : ι → Set X) :=
  ∀ x : X, { i | x ∈ U i }.Countable

def IsZero {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∃ f : C(X, ℝ), f.toFun ⁻¹' {0} = s

def IsCozero {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∃ f : C(X, ℝ), f.toFun ⁻¹' {0}ᶜ = s

def IsRelativelyCompact {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∀ {ι : Type u} (U : ι → Set X),
    ∃ t : Set ι, t.Finite ∧ s ⊆ ⋃ i ∈ t, U i

def IsDiscreteFamily {X : Type u} {ι : Type u} [TopologicalSpace X] (F : ι → Set X) : Prop :=
  ∀ x : X, ∃ U ∈ 𝓝 x, {i : ι | F i ∩ U ≠ ∅}.encard ≤ 1

--TODO: Notation Σ' for this?
/-- Sigma product (of topological spaces).
Not to be confused with the disjoint union (topological sum). -/
def SigmaProduct {ι : Type*} {Y : ι → Type u} (x : (i : ι) → Y i) : Set ((i : ι) → Y i) :=
  {s : (i : ι) → Y i | {i : ι | s i ≠ x i}.Countable}

def IsRetraction {X : Type u} [TopologicalSpace X] (A : Set X) : Prop :=
  ∃ f : C(X, X), f.comp f = f ∧ A = Set.range f

/-- Star of an open cover. -/
def CoverStar {X ι : Type*} (U : ι → Set X) [TopologicalSpace X] (x : X) :
    Set X := ⋃ i : ι, ⋃ (_ : x ∈ U i), U i

variable (A : Set ℕ)

def SigmaLocallyFinite {ω : ι → Type v} (f : (i : ι) → ω i → Set X) :=
  Countable ι ∧ ∀ i, LocallyFinite (f i)

def LocallyCountable (f : ι → Set X) :=
  ∀ x : X, ∃ t ∈ 𝓝 x, {i | (f i ∩ t).Nonempty}.Countable

def SigmaLocallyCountable {ω : ι → Type v} (f : (i : ι) → ω i → Set X) :=
  Countable ι ∧ ∀ i, LocallyCountable (f i)

def IsCutPoint (p : X) := ¬ IsConnected {p}ᶜ

/-- The image of the fundamental group of under f:X → Y at x : X is trivial. -/
def HasTrivialFundGroupImageAt (f : C(X, Y)) (x : X) : Prop :=
  ((FundamentalGroup.map f) x).range = ⊥

/-- A symmetric for of a set. -/
class Symmetric (α : Type u) extends Dist α where
  dist_self (x : α) : dist x x = 0
  dist_comm (x y : α) : dist x y = dist y x
  eq_of_dist_eq_zero : ∀ {x y : α}, dist x y = 0 → x = y

def Symmetric.ball {α : Type u} [Symmetric α] (a : α) (ε : ℝ) : Set α := {x : α | dist x a ≤ ε}

/-- A semimetric space -/
class SemimetricSpace (X : Type u) [TopologicalSpace X] extends Symmetric X where
  symmetric_nbhd (x : X) : (𝓝 x).HasBasis (fun ε => 0 < ε) (Symmetric.ball x)

/-- A symmetric space -/
class SymmetricSpace (X : Type u) [TopologicalSpace X] extends Symmetric X where
  isOpen_iff (s : Set X) : IsOpen s ↔ ∀ x ∈ s, ∃ ε > 0, Symmetric.ball x ε ⊆ s

end AdditionalDefs

end PiBase

end Topology
