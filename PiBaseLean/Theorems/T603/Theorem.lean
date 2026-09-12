module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P26.Bundled
public import PiBaseLean.Properties.P209.Bundled

@[expose] public section

universe u

open Set Cardinal TopologicalSpace

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- Theorem T603: P26 ≤ P209

A countable dense set has cardinality at most `ℵ₀ ≤ 𝔠`. -/
theorem instDensityLeContinuumOfSeparableSpace [SeparableSpace X] : DensityLeContinuum X := by
  obtain ⟨s, hcount, hdense⟩ := exists_countable_dense X
  have : Countable s := hcount
  exact ⟨s, hdense, le_trans Cardinal.mk_le_aleph0 Cardinal.aleph0_le_continuum⟩

end PiBase

namespace PiBase.Formal

theorem T603 : P26 ≤ P209 := fun X _ h ↦ @instDensityLeContinuumOfSeparableSpace X _ h

end PiBase.Formal
