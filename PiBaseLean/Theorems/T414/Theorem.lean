module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P99.Bundled
public import PiBaseLean.Properties.P167.Bundled

@[expose] public section

universe u

open Set Filter Topology

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- Theorem T414: P167 ≤ P99

A convergent sequence is eventually constant at each of its limits, and two eventually-true
conditions hold simultaneously somewhere, so the limits agree. -/
theorem instUsSpaceOfSeqDiscreteSpace [h : SeqDiscreteSpace X] : UsSpace X := by
  refine ⟨fun f a b ha hb ↦ ?_⟩
  obtain ⟨n, hn₁, hn₂⟩ := ((h.tendsto_constant f a ha).and (h.tendsto_constant f b hb)).exists
  exact hn₁.symm.trans hn₂

end PiBase

namespace PiBase.Formal

theorem T414 : P167 ≤ P99 := fun X _ h ↦ @instUsSpaceOfSeqDiscreteSpace X _ h

end PiBase.Formal
