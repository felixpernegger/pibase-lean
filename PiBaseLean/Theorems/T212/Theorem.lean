module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P27.Bundled
public import PiBaseLean.Properties.P28.Bundled
public import PiBaseLean.Properties.P57.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T212: P57 (Countable) + P28 (FirstCountableTopology) => P27 (SecondCountableTopology) -/
theorem instSecondCountableTopologyOfCountableOfFirstCountableTopology {X : Type u}
    [TopologicalSpace X] [Countable X] [FirstCountableTopology X] :
    SecondCountableTopology X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T212 : P57 ⊓ P28 ≤ P27 :=
  fun X _ ↦ and_imp.2 (@instSecondCountableTopologyOfCountableOfFirstCountableTopology X _)

end PiBase.Formal
