module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P31.Defs
public import PiBaseLean.Properties.P83.Defs

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T586: P31 (MetacompactSpace) => P83 (MetaLindelofSpace) -/
instance instMetaLindelofSpaceOfMetacompactSpace (X : Type u)
    [TopologicalSpace X] [h : MetacompactSpace X] :
    MetaLindelofSpace X where
  meta_lindelof ι s s_open s_cover :=
    let ⟨β, t, t_open, t_cover, ht, ts⟩ := h.metacompact ι s s_open s_cover
    ⟨β, t, t_open, t_cover, ht.PointCountable, ts⟩

end PiBase

namespace PiBase.Formal

theorem T586 : P31 ≤ P83 := fun X _ ↦ @instMetaLindelofSpaceOfMetacompactSpace X _

end PiBase.Formal
