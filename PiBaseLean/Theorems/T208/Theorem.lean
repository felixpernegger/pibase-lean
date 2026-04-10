module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P125.Defs
public import PiBaseLean.Properties.P129.Defs
public import PiBaseLean.Properties.P139.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

-- Most likely redundant
/-- Theorem T208: P129 (IndiscreteTopology) + P125 (Nontrivial) => P139 (¬HasAnIsolatedPoint) -/
theorem not_HasAnIsolatedPointOfIndiscreteTopologyOfNontrivial (X : Type u)
    [TopologicalSpace X] [h : IndiscreteTopology X] [h' : Nontrivial X] :
    ¬ HasAnIsolatedPoint X := by
  contrapose! h'
  obtain ⟨p, ph⟩ := h'.ex_isolated
  refine (subsingleton_iff_forall_eq p).mpr fun x ↦ ?_
  have puniv := (h.isOpen_iff {p}).1 ph
  simp only [singleton_ne_empty, false_or] at puniv
  exact mem_singleton_iff.mp <| puniv ▸ mem_univ x

end PiBase

namespace PiBase.Formal

theorem T208 : P129 ⊓ P125 ≤ P139ᶜ := fun X _ ⟨h1, h2⟩ ↦
  @not_HasAnIsolatedPointOfIndiscreteTopologyOfNontrivial X _ h1 h2

end PiBase.Formal
