module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P47.Defs
public import PiBaseLean.Properties.P52.Defs
public import PiBaseLean.Properties.P234.Defs
public import PiBaseLean.Properties.P234.Lemmas

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T108: P234 (HasOpenConnectedComponents) + P47 (TotallyDisconnectedSpace) =>
P52 (DiscreteTopology) -/
instance instDiscreteTopologyOfHasOpenConnectedComponentsOfTotallyDisconnectedSpace (X : Type u)
    [TopologicalSpace X] [h : HasOpenConnectedComponents X] [h' : TotallyDisconnectedSpace X] :
      DiscreteTopology X := by
  apply discreteTopology_iff_isOpen_singleton.mpr (fun x ↦ ?_)
  rw [← totallyDisconnectedSpace_iff_connectedComponent_singleton.1 h' x]
  exact h.component_open x

end PiBase

namespace PiBase.Formal

theorem T108 : P234 ⊓ P47 ≤ P52 :=
  fun X _ ⟨h1, h2⟩ ↦ @instDiscreteTopologyOfHasOpenConnectedComponentsOfTotallyDisconnectedSpace X _ h1 h2

end PiBase.Formal
