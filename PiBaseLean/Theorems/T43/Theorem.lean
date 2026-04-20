module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Lemmas
public import PiBaseLean.Properties.P47.Lemmas
public import PiBaseLean.Properties.P51.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

--TODO: golf
/-- Theorem T43: P2 (T1Space) + P51 (ScatteredSpace) => P47 (TotallyDisconnectedSpace) -/
instance instTotallyDisconnectedSpaceOfT1SpaceOfScatteredSpace (X : Type u)
    [TopologicalSpace X] [T1Space X] [h : ScatteredSpace X] : TotallyDisconnectedSpace X := by
  refine totallyDisconnectedSpace_iff_connectedComponent_singleton.mpr (fun x ↦ ?_)
  obtain ⟨p, hp⟩ := h.scattered (connectedComponent x) connectedComponent_nonempty
  have e : IsClopen {p} := ⟨T1Space.t1 p, hp⟩
  --make this separate lemma
  have : ConnectedSpace (connectedComponent x) :=
    Subtype.connectedSpace isConnected_connectedComponent
  refine eq_singleton_iff_unique_mem.mpr ⟨mem_connectedComponent, ?_⟩
  intro r hr
  have t1 := e.eq_univ (singleton_nonempty p) ▸ mem_univ (⟨r, hr⟩ : connectedComponent x)
  have t2 := e.eq_univ (singleton_nonempty p) ▸
    mem_univ (⟨x, mem_connectedComponent⟩ : connectedComponent x)
  obtain ⟨_, _⟩ := p
  simp_all

end PiBase

namespace PiBase.Formal

theorem T43 : P2 ⊓ P51 ≤ P47 :=
  fun X _ ⟨h1, h2⟩ ↦ @instTotallyDisconnectedSpaceOfT1SpaceOfScatteredSpace X _ h1 h2

end PiBase.Formal
