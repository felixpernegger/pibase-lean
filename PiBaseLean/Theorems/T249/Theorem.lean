module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P125.Bundled
public import PiBaseLean.Properties.P129.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T249: ¬P125 (Nontrivial) => P129 (IndiscreteTopology) -/
theorem instIndiscreteTopologyOfSubsingleton {X : Type u}
    [TopologicalSpace X] [Subsingleton X] : IndiscreteTopology X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T249 : P125ᶜ ≤ P129 :=
  fun X _ h ↦ have : Subsingleton X := not_nontrivial_iff_subsingleton.mp h
    @instIndiscreteTopologyOfSubsingleton X _ ‹_›

end PiBase.Formal
