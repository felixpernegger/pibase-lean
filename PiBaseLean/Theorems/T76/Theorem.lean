import PiBaseLean.Properties.P60.Defs
import PiBaseLean.Properties.P22.Defs

open Topology Set Function

namespace PiBase

/- Theorem 76: a strongly connected space is pseudocompact -/
instance instStrnglyConnectedSpaceOfPseudocompactSpace
    {X : Type*} [TopologicalSpace X] [h : StronglyConnectedSpace X] :
    PseudocompactSpace X where
  pseudocompact f hf := by
    obtain ⟨r, hr⟩ := h.strongly_connected f hf
    by_cases n : Nonempty X
    · rw [hr]
      simp_all [(range_eq_singleton_iff (f := const X r) (y := r)).mpr <| congrFun rfl]
    simp [range_eq_empty_iff.mpr <| not_nonempty_iff.mp n]

end PiBase
