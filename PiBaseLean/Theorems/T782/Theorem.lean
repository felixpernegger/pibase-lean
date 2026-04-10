module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P52.Defs
public import PiBaseLean.Properties.P78.Defs
public import PiBaseLean.Properties.P222.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T782: P52 (DiscreteTopology) + P78 (Finite) => P222 (HasCofiniteTopology) -/
instance instHasCofiniteTopologyOfDiscreteTopologyOfFinite (X : Type u)
    [TopologicalSpace X] [DiscreteTopology X] [Finite X] :
    HasCofiniteTopology X where
  open_iff_cofinite s := ⟨fun _ ↦ fun _ ↦ toFinite sᶜ, fun _ ↦ isOpen_discrete s⟩

end PiBase

namespace PiBase.Formal

theorem T782 : P52 ⊓ P78 ≤ P222 := fun X _ ↦
  and_imp.2 (@instHasCofiniteTopologyOfDiscreteTopologyOfFinite X _)

end PiBase.Formal
