import PiBaseLean.Properties.P219.Defs
import Mathlib

open Topology Set Function TopologicalSpace Filter

namespace PiBase

/- Theorem 818: A finite space is Toronto. -/
instance instTorontoSpaceOfFinite [Finite X] : TorontoSpace X where
  toronto := by
    intro Y hY
    have eq : Y = Set.univ := by
      refine (Set.eq_univ_iff_ncard Y).mpr ?_
      have : Y.ncard = (#↑Y).toNat := by
        exact rfl
      rw [this, hY]
      exact rfl
    rw [eq]
    exact Homeomorph.Set.univ X

end PiBase
