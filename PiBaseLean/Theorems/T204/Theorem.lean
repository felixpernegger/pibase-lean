module

public import PiBaseLean.Properties.Bundled.Basic
public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.P52.Defs
public import PiBaseLean.Properties.P86.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T204: P52 (DiscreteTopology) => P86 (HomogeneousSpace)
Note the use of `classical` -/
instance instHomogeneousSpaceOfDiscreteTopology (X : Type u)
    [TopologicalSpace X] [h : DiscreteTopology X] :
    HomogeneousSpace X where
  homogeneous x y := by
    classical
    exact ⟨Homeomorph.ofDiscrete <| Equiv.swap x y, by simp [Homeomorph.ofDiscrete]⟩

end PiBase

namespace PiBase.Formal

theorem T204 : P52 ≤ P86 := fun X _ ↦ @instHomogeneousSpaceOfDiscreteTopology X _

end PiBase.Formal
