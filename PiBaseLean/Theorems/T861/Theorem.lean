module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P233.Bundled
public import PiBaseLean.Properties.P42.Bundled

@[expose] public section

universe u

open Set Filter

namespace PiBase

/-- Theorem T861: P42 (LocallyPathConnectedSpace) => P233 (HasOpenPathComponents) -/
instance instHasOpenPathComponentsOfLocallyPathConnectedSpace {X : Type u}
    [TopologicalSpace X] [h : LocallyPathConnectedSpace X] : HasOpenPathComponents X := by
  apply (hasOpenPathComponents_iff_ex_connected_nbhd X).mpr fun x ↦ ?_
  obtain ⟨s, ⟨so, sc⟩, _⟩ := (hasBasis_iff.mp (h.path_connected_basis x) univ).mp univ_mem
  exact ⟨s, Filter.mem_sets.mp so, sc⟩

end PiBase

namespace PiBase.Formal

theorem T861 : P42 ≤ P233 := fun X _ ↦ @instHasOpenPathComponentsOfLocallyPathConnectedSpace X _

end PiBase.Formal
