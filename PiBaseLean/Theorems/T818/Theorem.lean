module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P219.Bundled
public import PiBaseLean.Properties.P78.Bundled

import Mathlib.Data.Set.Card

@[expose] public section

open Cardinal

namespace PiBase

/- Theorem 818: a finite space is Toronto. -/
instance instTorontoSpaceOfFinite {X : Type*} [TopologicalSpace X] [Finite X] : TorontoSpace X where
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
