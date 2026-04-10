module

public import Mathlib.Topology.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

/- 193. Shrinking -/
class ShrinkingSpace (X : Type u) [TopologicalSpace X] : Prop where
  closure_refinement :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → ⋃ a, s a = univ →
      ∃ (t : α → Set X), (∀ a, IsOpen (t a)) ∧ ⋃ a, t a = univ ∧ ∀ a, closure (t a) ⊆ s a

end PiBase

namespace PiBase.Formal

def P193 : Property where
  toPred := ShrinkingSpace
  well_defined φ h := sorry

end PiBase.Formal
