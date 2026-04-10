module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P93.Defs
public import PiBaseLean.Properties.P94.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T564: P94 (LocallyFiniteSpace) => P93 (LocallyCountableSpace) -/
instance instLocallyCountableSpaceOfLocallyFiniteSpace (X : Type u)
    [TopologicalSpace X] [h : LocallyFiniteSpace X] :
    LocallyCountableSpace X where
  locally_countable x := by
    obtain ⟨s, sx, hs⟩ := h.locally_finite x
    exact ⟨s, sx, Finite.countable hs⟩

end PiBase

namespace PiBase.Formal

theorem T564 : P94 ≤ P93 := fun X _ ↦ @instLocallyCountableSpaceOfLocallyFiniteSpace X _

end PiBase.Formal
