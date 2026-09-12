module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P26.Bundled
public import PiBaseLean.Properties.P201.Bundled

@[expose] public section

universe u

open Set TopologicalSpace

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- Theorem T592: P201 ≤ P26

A generic point `p` has `closure {p} = univ`, so the singleton `{p}` is a countable dense set. -/
theorem instSeparableSpaceOfHasGenericPoint [h : HasGenericPoint X] : SeparableSpace X := by
  obtain ⟨p, hp⟩ := h.ex_generic_point
  exact ⟨{p}, countable_singleton p, dense_iff_closure_eq.2 hp⟩

end PiBase

namespace PiBase.Formal

theorem T592 : P201 ≤ P26 := fun X _ h ↦ @instSeparableSpaceOfHasGenericPoint X _ h

end PiBase.Formal
