module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P87.Defs
public import PiBaseLean.Properties.P137.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T346: P87 (HasGroupTopology) => P137ᶜ (Nonempty) -/
theorem instNonemptyOfHasGroupTopology (X : Type u)
    [TopologicalSpace X] [h : HasGroupTopology X] : Nonempty X :=
  let ⟨_, _⟩ := h.has_group_topology
  One.instNonempty

end PiBase

namespace PiBase.Formal

theorem T346 : P87 ≤ P137ᶜ := fun X _ h ↦ not_isEmpty_iff.2 (@instNonemptyOfHasGroupTopology X _ h)

end PiBase.Formal
