module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P30.Defs
public import PiBaseLean.Properties.P31.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T14: P30 (ParacompactSpace) => P31 (MetacompactSpace) -/
instance instMetacompactSpaceOfParacompactSpace (X : Type u)
    [TopologicalSpace X] [h : ParacompactSpace X] :
    MetacompactSpace X where
  metacompact α s sp sc :=
    let ⟨β, t, tp, tc, ht, ts⟩ := h.locallyFinite_refinement α s sp sc
    ⟨β, t, tp, tc, LocallyFinite.PointFinite ht, ts⟩

end PiBase

namespace PiBase.Formal

theorem T14 : P30 ≤ P31 := fun X _ ↦ @instMetacompactSpaceOfParacompactSpace X _

end PiBase.Formal
