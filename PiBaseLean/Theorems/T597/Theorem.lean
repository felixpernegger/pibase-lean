module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P39.Bundled
public import PiBaseLean.Properties.P139.Bundled
public import PiBaseLean.Properties.P201.Bundled

@[expose] public section

universe u

open Set

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- Theorem T597: P39 ⊓ P139 ≤ P201

If `p` is isolated then `{p}` is nonempty open, so hyperconnectedness makes every nonempty
open set meet `{p}` — that is, contain `p`. Hence every neighbourhood of every point meets
`{p}`, so `closure {p}` is everything. -/
theorem instHasGenericPointOfPreirreducibleSpaceOfHasAnIsolatedPoint
    [hp : PreirreducibleSpace X] [hi : HasAnIsolatedPoint X] : HasGenericPoint X := by
  obtain ⟨p, hop⟩ := hi.ex_isolated
  refine ⟨p, ?_⟩
  refine Set.eq_univ_of_forall fun x ↦ mem_closure_iff.2 fun U hU hxU ↦ ?_
  obtain ⟨z, _, hz⟩ := hp.isPreirreducible_univ {p} U hop hU ⟨p, trivial, rfl⟩ ⟨x, trivial, hxU⟩
  exact ⟨z, hz.2, hz.1⟩

end PiBase

namespace PiBase.Formal

theorem T597 : P39 ⊓ P139 ≤ P201 := fun X _ ⟨h1, h2⟩ ↦
  @instHasGenericPointOfPreirreducibleSpaceOfHasAnIsolatedPoint X _ h1 h2

end PiBase.Formal
