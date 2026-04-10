module

public import Mathlib.Topology.Metrizable.Uniformity
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P53.Defs
public import PiBaseLean.Properties.P220.Defs

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/-- Theorem T770: P220 (UltraMetrizableSpace) => P53 (MetrizableSpace) -/
instance instMetrizableSpaceOfUltraMetrizableSpace (X : Type u)
    [τ : TopologicalSpace X] [h : UltraMetrizableSpace X] :
    MetrizableSpace X := by
  obtain ⟨m, _, eq⟩ := h.ex_ultrametric
  exact eq ▸ EMetricSpace.metrizableSpace

end PiBase

namespace PiBase.Formal

theorem T770 : P220 ≤ P53 := fun X _ ↦ @instMetrizableSpaceOfUltraMetrizableSpace X _

end PiBase.Formal
