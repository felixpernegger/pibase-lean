module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P51.Lemmas
public import PiBaseLean.Properties.P137.Defs
public import PiBaseLean.Properties.P139.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T306: P51 (ScatteredSpace) + ¬P137 (IsEmpty) => P139 (HasAnIsolatedPoint) -/
instance instHasAnIsolatedPointOfScatteredSpaceOfNonempty (X : Type u)
    [TopologicalSpace X] [h : ScatteredSpace X] [Nonempty X] : HasAnIsolatedPoint X := by
  obtain ⟨⟨p, _⟩, hp⟩ := h.scattered univ univ_nonempty
  obtain ⟨s, so, hs⟩ := hp
  refine ⟨p, ?_⟩
  suffices s = {p} by
    rwa [← this]
  have := Set.ext_iff.1 hs
  simp only [mem_preimage, mem_singleton_iff, Subtype.forall, mem_univ, Subtype.mk.injEq,
    forall_const] at this
  exact ext this

end PiBase

namespace PiBase.Formal

theorem T306 : P51 ⊓ P137ᶜ ≤ P139 :=
  fun X _ ⟨h1, h2⟩ ↦ haveI : Nonempty X := not_isEmpty_iff.mp h2
    @instHasAnIsolatedPointOfScatteredSpaceOfNonempty X _ h1 ‹_›

end PiBase.Formal
