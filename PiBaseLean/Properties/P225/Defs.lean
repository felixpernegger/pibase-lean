module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs
public import Mathlib.Topology.UnitInterval

@[expose] public section

universe u

namespace PiBase

open Topology Filter Set Function

/- 225. LC -/
class LCSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_contractible (x : X) (s : Set X) (h : s ∈ 𝓝 x) :
    ∃ (t : Set X), t ∈ 𝓝 x ∧
      ∃ f : t × unitInterval → X, Continuous f ∧ range f ⊆ s ∧
        (∀ i, f (i, 0) = i.val) ∧  (∀ i, f (i, 1) = x)

end PiBase

namespace PiBase.Formal

def P225 : Property where
  toPred := LCSpace
  well_defined φ h := sorry

end PiBase.Formal
