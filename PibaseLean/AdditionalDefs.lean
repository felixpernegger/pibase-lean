import Mathlib

universe u v

namespace Topology

namespace PiBase

namespace AdditionalDefs

variable {X : Type*} {Y : Type*} [TopologicalSpace X]

variable {ι ι' α X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y] {f g : ι → Set X}

def PointFinite (U : ι → Set X) :=
  ∀ x : X, { i | x ∈ U i }.Finite

def IsCozero {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∃ f : C(X, ℝ), f.toFun ⁻¹' {0}ᶜ = s
/-
def IsSigmaLocallyFinite (A : Set (Set X)) : Prop :=
  0 = 0
-/

def IsRelativelyCompact {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∀ {ι : Type u} (U : ι → Set X),
    ∃ t : Set ι, t.Finite ∧ s ⊆ ⋃ i ∈ t, U i


#check LocallyFinite

end AdditionalDefs
end PiBase
end Topology
