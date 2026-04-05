import PiBaseLean.Properties.P219.Defs
import Mathlib

open Topology Set Function TopologicalSpace Filter Cardinal

namespace PiBase

/- Theorem 818: a finite space is Toronto. -/
instance instTorontoSpaceOfFinite (X : Type*) [TopologicalSpace X] [Finite X] : TorontoSpace X where
  toronto Y hY := by
    have eq : Y = .univ := by
      apply (Set.eq_univ_iff_ncard Y).mpr
      change (#↑Y).toNat = Nat.card X
      rw [hY]
      exact rfl
    rw [eq]
    exact Homeomorph.Set.univ X

end PiBase
