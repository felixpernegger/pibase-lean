module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P42.Defs
public import PiBaseLean.Properties.P233.Defs
public import PiBaseLean.Properties.P233.Lemmas

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T861: P42 (LocPathConnectedSpace) => P233 (HasOpenPathComponents) -/
instance instHasOpenPathComponentsOfLocPathConnectedSpace (X : Type u)
    [TopologicalSpace X] [h : LocPathConnectedSpace X] : HasOpenPathComponents X := by
  apply (hasOpenPathComponents_iff_ex_connected_nbhd X).mpr fun x ↦ ?_
  obtain ⟨s, ⟨so, sc⟩, _⟩ := (hasBasis_iff.mp (h.path_connected_basis x) univ).mp univ_mem
  exact ⟨s, Filter.mem_sets.mp so, sc⟩

end PiBase

namespace PiBase.Formal

theorem T861 : P42 ≤ P233 := fun X _ ↦ @instHasOpenPathComponentsOfLocPathConnectedSpace X _

end PiBase.Formal
