module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P231.Defs
public import PiBaseLean.Properties.P233.Defs
public import PiBaseLean.Properties.P233.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T859: P231 (WeaklyLocallySimplyConnectedSpace) => P233 (HasOpenPathComponents) -/
instance instHasOpenPathComponentsOfWeaklyLocallySimplyConnectedSpace (X : Type u)
    [TopologicalSpace X] [h : WeaklyLocallySimplyConnectedSpace X] :
    HasOpenPathComponents X := by
  apply (hasOpenPathComponents_iff_ex_connected_nbhd X).mpr (fun x ↦ ?_)
  obtain ⟨s, sx, hs⟩ := h.simply_connected_nbhd x
  exact ⟨s, sx, IsSimplyConnected.isPathConnected hs⟩

end PiBase

namespace PiBase.Formal

theorem T859 : P231 ≤ P233 := fun X _ ↦ @instHasOpenPathComponentsOfWeaklyLocallySimplyConnectedSpace X _

end PiBase.Formal
