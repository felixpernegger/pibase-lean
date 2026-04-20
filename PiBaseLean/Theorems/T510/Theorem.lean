module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P52.Lemmas
public import PiBaseLean.Properties.P147.Lemmas
public import PiBaseLean.Properties.P191.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T510: P147 (P space) + P191 (Has points Gδ) => P52 (Discrete) -/
instance instDiscreteTopologyOfPSpaceOfHasGδSingletons (X : Type u)
    [TopologicalSpace X] [h : PSpace X] [h' : HasGδSingletons X] : DiscreteTopology X :=
  discreteTopology_iff_isOpen_singleton.mpr (fun a ↦ h.isGδ_open <| h'.isGδ_singleton a)

end PiBase

namespace PiBase.Formal

theorem T510 : P147 ⊓ P191 ≤ P52 :=
  fun X _ ⟨h1, h2⟩ ↦ @instDiscreteTopologyOfPSpaceOfHasGδSingletons X _ h1 h2

end PiBase.Formal
