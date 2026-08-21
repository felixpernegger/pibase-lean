module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P137.Bundled
public import PiBaseLean.Properties.P87.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T346: P87 (HasGroupTopology) => P137ᶜ (Nonempty) -/
theorem instNonemptyOfHasGroupTopology {X : Type u}
    [TopologicalSpace X] [h : HasGroupTopology X] : Nonempty X :=
  let ⟨_, _⟩ := h.has_group_topology
  One.instNonempty

end PiBase

namespace PiBase.Formal

theorem T346 : P87 ≤ P137ᶜ := fun X _ h ↦ not_isEmpty_iff.2 (@instNonemptyOfHasGroupTopology X _ h)

end PiBase.Formal
