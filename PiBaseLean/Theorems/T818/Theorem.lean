module

public import Mathlib.Data.Set.Card
public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P78.Defs
public import PiBaseLean.Properties.P219.Defs

@[expose] public section

open Topology Set Function TopologicalSpace Filter Cardinal

namespace PiBase

/- Theorem 818: a finite space is Toronto. -/
instance instTorontoSpaceOfFinite (X : Type*) [TopologicalSpace X] [Finite X] : TorontoSpace X where
  toronto Y hY :=
    have eq : Y = .univ := by
      apply (Set.eq_univ_iff_ncard Y).mpr
      change (#↑Y).toNat = Nat.card X
      rw [hY]
      exact rfl
    eq ▸ (Nonempty.intro <| Homeomorph.Set.univ X)

end PiBase

namespace PiBase.Formal

theorem T818 : P78 ≤ P219 := @instTorontoSpaceOfFinite

end PiBase.Formal
