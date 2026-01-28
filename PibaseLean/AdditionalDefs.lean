import Mathlib

universe u v

namespace Topology

namespace PiBase

namespace AdditionalDefs

open Filter Function Set Topology TopologicalSpace

variable {X : Type*} {Y : Type*} [TopologicalSpace X]

variable {ι ι' α X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y] {f g : ι → Set X}

def PointFinite (U : ι → Set X) :=
  ∀ x : X, { i | x ∈ U i }.Finite

def PointCountable (U : ι → Set X) :=
  ∀ x : X, { i | x ∈ U i }.Countable

def IsCozero {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∃ f : C(X, ℝ), f.toFun ⁻¹' {0}ᶜ = s
/-
def IsSigmaLocallyFinite (A : Set (Set X)) : Prop :=
  0 = 0
-/

def IsRelativelyCompact {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∀ {ι : Type u} (U : ι → Set X),
    ∃ t : Set ι, t.Finite ∧ s ⊆ ⋃ i ∈ t, U i

def IsDiscreteFamily {X : Type u} {ι : Type u} [TopologicalSpace X] (F : ι → Set X) : Prop :=
  ∀ x : X, ∃ U ∈ 𝓝 x, {i : ι | F i ∩ U ≠ ∅}.encard ≤ 1

def SigmaProduct {ι : Type*} {Y : ι → Type u} (x : (i : ι) → Y i) : Set ((i : ι) → Y i) :=
  {s : (i : ι) → Y i | {i : ι | s i ≠ x i}.Countable}

def IsRetract {X : Type u} [TopologicalSpace X] {A : Set X} (f : X → A) : Prop :=
  Continuous f ∧ ∀ a ∈ A, f a = a

def IsRetractSet {X : Type u} [TopologicalSpace X] (A : Set X) : Prop :=
  ∃ f : X → A, IsRetract f

variable (A : Set ℕ)

def LocallyCountable (f : ι → Set X) :=
  ∀ x : X, ∃ t ∈ 𝓝 x, { i | (f i ∩ t).Nonempty }.Finite

#check LocallyFinite
end AdditionalDefs
end PiBase
end Topology
