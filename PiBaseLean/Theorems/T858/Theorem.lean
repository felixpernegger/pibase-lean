import PiBaseLean.Properties.P200.Defs
import PiBaseLean.Properties.P231.Defs

open Topology Set Function Filter

open CategoryTheory
open scoped ContinuousMap

namespace PiBase

-- TODO: Add IsSimplyConnetced univ ↔ SimplyConnectedSpace X to mathlib

/- Theorem 858: a simply connected space is weakly locally simply connected -/
instance instWeaklyLocallySimplyConnectedSpaceOfSimplyConnectedSpace
    {X : Type*} [TopologicalSpace X] [h : PreSimplyConnectedSpace X] :
    WeaklyLocallySimplyConnectedSpace X where
  simply_connected_nbhd x := by
    obtain h'|h' := h.presimplyconnected
    · exact False.elim <| IsEmpty.false x
    · refine ⟨univ, univ_mem, ?_⟩
      let e : X ≃ₕ univ (α := X) := Homeomorph.toHomotopyEquiv (Homeomorph.Set.univ X).symm
      exact (ContinuousMap.HomotopyEquiv.simplyConnectedSpace_iff e).mp h'

end PiBase
