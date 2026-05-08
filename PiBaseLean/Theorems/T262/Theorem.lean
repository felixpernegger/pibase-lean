module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P39.Lemmas
public import PiBaseLean.Properties.P129.Lemmas
public import PiBaseLean.Properties.P134.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T262: P134 (R1Space) + P39 (PreirreducibleSpace) => P129 (IndiscreteTopology) -/
instance instIndiscreteTopologyOfR1SpaceOfPreirreducibleSpace (X : Type u)
    [TopologicalSpace X] [R1Space X] [i : PreirreducibleSpace X] : IndiscreteTopology X := by
  refine IndiscreteTopology.of_forall_inseparable (fun x y ↦ ?_)
  by_contra h0
  obtain ⟨s, t, hs, ht, xs, yt, st⟩ := r1_separation h0
  have := i.isPreirreducible_univ s t hs ht (by simp [nonempty_of_mem xs])
    (by simp [nonempty_of_mem yt])
  rw [univ_inter] at this
  exact (not_disjoint_iff_nonempty_inter.mpr this) st

end PiBase

namespace PiBase.Formal

theorem T262 : P134 ⊓ P39 ≤ P129 :=
  fun X _ ⟨h1, h2⟩ ↦ @instIndiscreteTopologyOfR1SpaceOfPreirreducibleSpace X _ h1 h2

end PiBase.Formal
