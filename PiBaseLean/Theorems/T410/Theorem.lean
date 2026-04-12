module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P112.Defs
public import PiBaseLean.Properties.P166.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T410: P166 (HasCoarserSeparableMetrizableTopology ) => P112 (SubmetrizableSpace) -/
instance instSubmetrizableSpaceOfHasCoarserSeparableMetrizableTopology (X : Type u)
    [TopologicalSpace X] [h : HasCoarserSeparableMetrizableTopology X] :
    SubmetrizableSpace X where
  le_metrizable :=
    let ⟨m, hm, _⟩ := h.ex_coarser_metrizable_separable
    ⟨m, hm⟩

end PiBase

namespace PiBase.Formal

theorem T410 : P166 ≤ P112 := fun X _ ↦ @instSubmetrizableSpaceOfHasCoarserSeparableMetrizableTopology X _

end PiBase.Formal
