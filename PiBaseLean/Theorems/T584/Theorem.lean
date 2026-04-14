module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P137.Defs
public import PiBaseLean.Properties.P199.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T584: P199 (ContractibleSpace) => P137ᶜ (Nonempty) -/
theorem instNonemptyOfContractibleSpace (X : Type u)
    [TopologicalSpace X] [h : ContractibleSpace X] : Nonempty X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T584 : P199 ≤ P137ᶜ := fun X _ h ↦ not_isEmpty_iff.2 (@instNonemptyOfContractibleSpace X _ h)

end PiBase.Formal
