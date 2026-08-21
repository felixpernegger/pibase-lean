module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P112.Bundled
public import PiBaseLean.Properties.P53.Bundled

import Mathlib.Topology.Metrizable.Uniformity

@[expose] public section

universe u

open TopologicalSpace

namespace PiBase

-- Most likely redundant
/-- Theorem T407: P53 (MetrizableSpace) => P112 (SubmetrizableSpace) -/
instance instSubmetrizableSpaceOfMetrizableSpace {X : Type u}
    [τ : TopologicalSpace X] [MetrizableSpace X] :
    SubmetrizableSpace X where
  le_metrizable := ⟨metrizableSpaceMetric X, le_refl τ⟩

end PiBase

namespace PiBase.Formal

theorem T407 : P53 ≤ P112 := fun X _ ↦ @instSubmetrizableSpaceOfMetrizableSpace X _

end PiBase.Formal
