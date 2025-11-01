import Mathlib

universe u v

namespace Topology

namespace PiBase

namespace AdditionalDefs

variable {X : Type*} {Y : Type*} [TopologicalSpace X]

variable {ι ι' α X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y] {f g : ι → Set X}

def PointFinite (f : ι → Set X) :=
  ∀ x : X, { i | x ∈ f i }.Finite

def IsCozeroSet (A : Set X) : Prop :=
  ∃ f : X → ℝ, Continuous f ∧ A = f ⁻¹' {(0 : ℝ)}

/-
def IsSigmaLocallyFinite (A : Set (Set X)) : Prop :=
  0 = 0
-/

#check LocallyFinite

end AdditionalDefs
end PiBase
end Topology
