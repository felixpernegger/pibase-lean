module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P147.Bundled
public import PiBaseLean.Properties.P191.Bundled
public import PiBaseLean.Properties.P52.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T510: P147 (P space) + P191 (Has points Gδ) => P52 (Discrete) -/
instance instDiscreteTopologyOfPSpaceOfHasGδSingletons {X : Type u}
    [TopologicalSpace X] [h : PSpace X] [h' : HasGδSingletons X] : DiscreteTopology X :=
  discreteTopology_iff_isOpen_singleton.mpr (fun a ↦ h.isGδ_open <| h'.isGδ_singleton a)

end PiBase

namespace PiBase.Formal

theorem T510 : P147 ⊓ P191 ≤ P52 :=
  fun X _ ⟨h1, h2⟩ ↦ @instDiscreteTopologyOfPSpaceOfHasGδSingletons X _ h1 h2

end PiBase.Formal
