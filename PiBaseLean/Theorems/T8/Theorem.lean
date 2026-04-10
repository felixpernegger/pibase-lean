module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P23.Defs
public import PiBaseLean.Properties.P25.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T8: P25 (ExhaustibleByCompacts) => P23 (WeaklyLocallyCompactSpace) -/
instance instWeaklyLocallyCompactSpaceOfExhaustibleByCompacts (X : Type u)
    [TopologicalSpace X] [h : ExhaustibleByCompacts X] :
    WeaklyLocallyCompactSpace X where
  exists_compact_mem_nhds x := by
    obtain ⟨s, s_compact, si, s_cover⟩ := h.exhaustion.some
    obtain ⟨n, hn⟩ := mem_iUnion.1 <| s_cover ▸ mem_univ x
    exact ⟨s (n + 1), s_compact (n + 1), mem_interior_iff_mem_nhds.mp (si n hn)⟩

end PiBase

namespace PiBase.Formal

theorem T8 : P25 ≤ P23 := fun X _ ↦ @instWeaklyLocallyCompactSpaceOfExhaustibleByCompacts X _

end PiBase.Formal
