module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P220.Bundled
public import PiBaseLean.Properties.P53.Bundled

import Mathlib.Topology.Metrizable.Uniformity

@[expose] public section

universe u

open TopologicalSpace

namespace PiBase

/-- Theorem T770: P220 (UltraMetrizableSpace) => P53 (MetrizableSpace) -/
instance instMetrizableSpaceOfUltraMetrizableSpace {X : Type u}
    [τ : TopologicalSpace X] [h : UltraMetrizableSpace X] :
    MetrizableSpace X := by
  obtain ⟨m, _, eq⟩ := h.ex_ultrametric
  exact eq ▸ EMetricSpace.metrizableSpace

end PiBase

namespace PiBase.Formal

theorem T770 : P220 ≤ P53 := fun X _ ↦ @instMetrizableSpaceOfUltraMetrizableSpace X _

end PiBase.Formal
