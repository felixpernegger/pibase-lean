module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P125.Bundled
public import PiBaseLean.Properties.P52.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T248: ¬P125 (Nontrivial) => P52 (DiscreteTopology) -/
theorem instDiscreteTopologyOfSubsingleton {X : Type u}
    [TopologicalSpace X] [Subsingleton X] : DiscreteTopology X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T248 : P125ᶜ ≤ P52 :=
  fun X _ h ↦ have : Subsingleton X := not_nontrivial_iff_subsingleton.mp h
    @instDiscreteTopologyOfSubsingleton X _ ‹_›

end PiBase.Formal
