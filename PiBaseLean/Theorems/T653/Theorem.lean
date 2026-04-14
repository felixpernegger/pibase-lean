module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P30.Defs
public import PiBaseLean.Properties.P105.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T653: P30 (ParacompactSpace) => P105 (ParaLindelofSpace) -/
instance instParaLindelofSpaceOfParacompactSpace (X : Type u)
    [TopologicalSpace X] [h : ParacompactSpace X] :
    ParaLindelofSpace X where
  para_lindelof α s so sc :=
    let ⟨β, t, tp, tc, ht, ts⟩ := h.locallyFinite_refinement α s so sc
    ⟨β, t, tp, tc, LocallyFinite.locallyCountable ht, ts⟩

end PiBase

namespace PiBase.Formal

theorem T653 : P30 ≤ P105 := fun X _ ↦ @instParaLindelofSpaceOfParacompactSpace X _

end PiBase.Formal
