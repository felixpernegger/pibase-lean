module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P233.Defs
public import PiBaseLean.Properties.P234.Defs
public import PiBaseLean.Properties.P233.Lemmas
public import PiBaseLean.Properties.P234.Lemmas

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T862: P233 (HasOpenPathComponents) => P234 (HasOpenConnectedComponents) -/
instance instHasOpenConnectedComponentsOfHasOpenPathComponents (X : Type u)
    [TopologicalSpace X] [h : HasOpenPathComponents X] : HasOpenConnectedComponents X := by
  refine (hasOpenConnectedComponents_iff_ex_connected_nbhd X).mpr (fun x ↦ ?_)
  obtain ⟨s, sx, hs⟩ := (hasOpenPathComponents_iff_ex_connected_nbhd X).mp h x
  exact ⟨s, sx, hs.isConnected⟩

end PiBase

namespace PiBase.Formal

theorem T862 : P233 ≤ P234 := fun X _ ↦ @instHasOpenConnectedComponentsOfHasOpenPathComponents X _

end PiBase.Formal
