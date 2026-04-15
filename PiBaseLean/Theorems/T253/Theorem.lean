module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P1.Defs
public import PiBaseLean.Properties.P125.Defs
public import PiBaseLean.Properties.P129.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T253: P125 (Nontrivial) + P1 (T0Space) => ¬P129 (IndiscreteTopology) -/
theorem instNotIndiscreteTopologyOfNontrivialOfT0Space (X : Type u)
    [TopologicalSpace X] [h : Nontrivial X] [h' : T0Space X] : ¬IndiscreteTopology X := by
  contrapose! h
  exact { allEq := fun a b ↦ h'.t0 <| Inseparable.all a b }

end PiBase

namespace PiBase.Formal

theorem T253 : P125 ⊓ P1 ≤ P129ᶜ :=
  fun X _ ⟨h1, h2⟩ ↦ @instNotIndiscreteTopologyOfNontrivialOfT0Space X _ h1 h2

end PiBase.Formal
