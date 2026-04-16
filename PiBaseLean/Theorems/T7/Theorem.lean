module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P23.Defs
public import PiBaseLean.Properties.P24.Defs

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T7: P24 (LocallyRelativelyCompactSpace) => P23 (WeaklyLocallyCompactSpace) -/
instance instWeaklyLocallyCompactSpaceOfLocallyRelativelyCompactSpace (X : Type u)
    [TopologicalSpace X] [h : LocallyRelativelyCompactSpace X] : WeaklyLocallyCompactSpace X where
  exists_compact_mem_nhds x :=
    let ⟨t, ⟨tx, tc⟩, _⟩ := (hasBasis_iff.mp (h.locally_relatively_compact x) univ).mp univ_mem
    ⟨closure t, tc, sets_of_superset (𝓝 x) tx subset_closure⟩

end PiBase

namespace PiBase.Formal

theorem T7 : P24 ≤ P23 := fun X _ ↦ @instWeaklyLocallyCompactSpaceOfLocallyRelativelyCompactSpace X _

end PiBase.Formal
