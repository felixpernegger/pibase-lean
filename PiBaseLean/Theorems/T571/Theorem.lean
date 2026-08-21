module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P203.Bundled
public import PiBaseLean.Properties.P52.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T571: P203 (AlmostDiscreteSpace) => P52 (¬DiscreteTopology) -/
theorem not_DiscreteTopologyOfAlmostDiscreteSpace {X : Type u}
    [TopologicalSpace X] [h : AlmostDiscreteSpace X] :
    ¬ DiscreteTopology X := by
  obtain ⟨p, hp⟩ := h.ex_point
  contrapose! hp
  exact ⟨p, Or.inr ⟨.refl p, isOpen_discrete {p}⟩⟩

end PiBase

namespace PiBase.Formal

theorem T571 : P203 ≤ P52ᶜ := fun X _ h ↦ @not_DiscreteTopologyOfAlmostDiscreteSpace X _ h

end PiBase.Formal
