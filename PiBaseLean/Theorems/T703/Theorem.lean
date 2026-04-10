module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P38.Defs
public import PiBaseLean.Properties.P95.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T703: P95 (ArcConnectedSpace) => P38 (InjPathConnectedSpace) -/
instance instInjPathConnectedSpaceOfArcConnectedSpace (X : Type u)
    [TopologicalSpace X] [h : ArcConnectedSpace X] :
    InjPathConnectedSpace X where
  joined x y xy _ _ := by
    obtain ⟨f, hf⟩ := h.joined xy
    refine ⟨f, hf.injective, subset_univ <| range f⟩

end PiBase

namespace PiBase.Formal

theorem T703 : P95 ≤ P38 := fun X _ ↦ @instInjPathConnectedSpaceOfArcConnectedSpace X _

end PiBase.Formal
