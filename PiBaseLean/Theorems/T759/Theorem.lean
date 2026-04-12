module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P123.Defs
public import PiBaseLean.Properties.P155.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T759: P155 (LocallyOneEuclideanSpace) => P123 (LocallyNEuclideanSpace) -/
instance instLocallyNEuclideanSpaceOfLocallyOneEuclideanSpace (X : Type u)
    [TopologicalSpace X] [h : LocallyOneEuclideanSpace X] :
    LocallyNEuclideanSpace X where
  locally_homeomorph := by
    refine ⟨1, fun x ↦ ?_⟩
    obtain ⟨s, sx, hs⟩ := h.locally_homeomorph x
    exact ⟨s, sx, IsHomeo.trans hs <| Nonempty.intro (Homeomorph.funUnique (Fin 1) ℝ).symm⟩

end PiBase

namespace PiBase.Formal

theorem T759 : P155 ≤ P123 := fun X _ ↦ @instLocallyNEuclideanSpaceOfLocallyOneEuclideanSpace X _

end PiBase.Formal
