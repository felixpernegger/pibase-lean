module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P41.Defs
public import PiBaseLean.Properties.P234.Defs
public import PiBaseLean.Properties.P234.Lemmas

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T863: P41 (LocallyConnectedSpace) => P234 (HasOpenConnectedComponents) -/
instance instHasOpenConnectedComponentsOfLocallyConnectedSpace (X : Type u)
    [TopologicalSpace X] [h : LocallyConnectedSpace X] : HasOpenConnectedComponents X := by
  apply (hasOpenConnectedComponents_iff_ex_connected_nbhd X).mpr fun x ↦ ?_
  obtain ⟨s, ⟨so, xs, sc⟩, _⟩ := (hasBasis_iff.mp (h.open_connected_basis x) univ).mp univ_mem
  exact ⟨s, so.mem_nhds_iff.mpr xs, sc⟩

end PiBase

namespace PiBase.Formal

theorem T863 : P41 ≤ P234 := fun X _ ↦ @instHasOpenConnectedComponentsOfLocallyConnectedSpace X _

end PiBase.Formal
