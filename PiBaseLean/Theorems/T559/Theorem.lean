module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P52.Defs
public import PiBaseLean.Properties.P57.Defs
public import PiBaseLean.Properties.P198.Defs
public import PiBaseLean.Properties.P198.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

-- Most likely redundant
/-- Theorem T559: P198 (HasCountableExtent) + P52 (DiscreteTopology) => P57 (Countable) -/
instance instCountableOfHasCountableExtentOfDiscreteTopology (X : Type u)
    [TopologicalSpace X] [h : HasCountableExtent X] [h' : DiscreteTopology X] :
    Countable X := by
  rw [hasCountableExtent_iff_discrete_countable] at h
  exact countable_univ_iff.mp <| h (DiscreteTopology.isDiscrete (s := univ)) isClosed_univ

end PiBase

namespace PiBase.Formal

theorem T559 : P198 ⊓ P52 ≤ P57 := fun X _ ⟨h1, h2⟩ ↦ @instCountableOfHasCountableExtentOfDiscreteTopology X _ h1 h2

end PiBase.Formal
