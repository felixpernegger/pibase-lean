module

public import Mathlib.Topology.Sets.Opens
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 109. Monotonically normal -/
class MonotonicallyNormalSpace (X : Type*) [TopologicalSpace X] : Prop extends T1Space X where
  monotonically_normal : ∃ μ : (x : X) → (s : Opens X) → (hs : x ∈ s) → Opens X,
    ∀ (x : X) (s : Opens X) (hs : x ∈ s), x ∈ μ x s hs ∧
      ∀ (x y : X) (u v : Opens X) (hu : x ∈ u) (hv : y ∈ v),
        (↑(μ x u hu) : Set X) ∩ ↑(μ y v hv) ≠ ∅ → x ∈ v ∨ y ∈ u

end PiBase

namespace PiBase.Formal

def P109 : Property where
  toPred := MonotonicallyNormalSpace
  well_defined φ h := sorry

end PiBase.Formal
