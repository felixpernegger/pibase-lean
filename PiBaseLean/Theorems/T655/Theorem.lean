module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P83.Defs
public import PiBaseLean.Properties.P105.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T655: P105 (ParaLindelofSpace) => P83 (MetaLindelofSpace) -/
instance instMetaLindelofSpaceOfParaLindelofSpace (X : Type u)
    [TopologicalSpace X] [h : ParaLindelofSpace X] :
    MetaLindelofSpace X where
  meta_lindelof ι s s_open s_cover :=
    let ⟨β, t, β_open, t_cover, lct, ts⟩ := h.para_lindelof ι s s_open s_cover
    ⟨β, t, β_open, t_cover, LocallyCountable.pointCountable lct, ts⟩

end PiBase

namespace PiBase.Formal

theorem T655 : P105 ≤ P83 := fun X _ ↦ @instMetaLindelofSpaceOfParaLindelofSpace X _

end PiBase.Formal
