module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P52.Defs
public import PiBaseLean.Properties.P125.Defs
public import Mathlib.Logic.Nontrivial.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T248: ¬P125 (Nontrivial) => P52 (DiscreteTopology) -/
theorem instDiscreteTopologyOfSubsingleton (X : Type u)
    [TopologicalSpace X] [Subsingleton X] : DiscreteTopology X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T248 : P125ᶜ ≤ P52 :=
  fun X _ h ↦ haveI : Subsingleton X := not_nontrivial_iff_subsingleton.mp h
    @instDiscreteTopologyOfSubsingleton X _ ‹_›

end PiBase.Formal
