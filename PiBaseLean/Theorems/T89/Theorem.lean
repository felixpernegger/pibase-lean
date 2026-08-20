module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P46.Bundled
public import PiBaseLean.Properties.P52.Bundled
public import PiBaseLean.Properties.P233.Bundled
public import PiBaseLean.Properties.P46.Bundled

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T89: P233 (HasOpenPathComponents) + P46 (TotallyPathDisconnectedSpace) =>
P52 (DiscreteTopology) -/
instance instDiscreteTopologyOfHasOpenPathComponentsOfTotallyPathDisconnectedSpace (X : Type u)
    [TopologicalSpace X] [h : HasOpenPathComponents X] [h' : TotallyPathDisconnectedSpace X] :
      DiscreteTopology X := by
  apply discreteTopology_iff_isOpen_singleton.mpr (fun x ↦ ?_)
  rw [← (totallyPathDisconnectedSpace_iff_pathComponent_singleton X).mp h' x]
  exact h.component_open x

end PiBase

namespace PiBase.Formal

theorem T89 : P233 ⊓ P46 ≤ P52 :=
  fun X _ ⟨h1, h2⟩ ↦
    @instDiscreteTopologyOfHasOpenPathComponentsOfTotallyPathDisconnectedSpace X _ h1 h2

end PiBase.Formal
