module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P163.Bundled
public import PiBaseLean.Properties.P209.Bundled

@[expose] public section

universe u

open Set Cardinal

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- Theorem T604: P163 ≤ P209

The whole space is dense in itself, and it has cardinality at most `𝔠` by hypothesis. -/
theorem instDensityLeContinuumOfCardLeContinuum [h : CardLeContinuum X] :
    DensityLeContinuum X :=
  ⟨univ, dense_univ, by rw [Cardinal.mk_univ]; exact h.card_le⟩

end PiBase

namespace PiBase.Formal

theorem T604 : P163 ≤ P209 := fun X _ h ↦ @instDensityLeContinuumOfCardLeContinuum X _ h

end PiBase.Formal
