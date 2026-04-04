import PibaseLean.Properties.P23.Defs
import PibaseLean.Properties.P24.Defs
import PibaseLean.Properties.P100.Defs
import Mathlib.Topology.Compactness.Compact

open Topology Set Function TopologicalSpace Filter

namespace PiBase

/- Theorem 81: A weakly locally compact KC space is
locally relatively compact. -/
instance instLocallyRelativelyCompactSpaceOfWeaklyLocallyCompactSpaceOfKC
    {X : Type*} [TopologicalSpace X] [h : WeaklyLocallyCompactSpace X] [h' : KcSpace X] :
    LocallyRelativelyCompactSpace X where
  locally_relatively_compact x := by
    obtain ⟨t, tc, xt⟩ := exists_compact_mem_nhds x
    apply hasBasis_self.mpr (fun r hr ↦ ⟨t ∩ r, inter_mem xt hr, ?_, inter_subset_right⟩)
    apply tc.of_isClosed_subset isClosed_closure
    nth_rw 2 [← closure_eq_iff_isClosed.mpr <| KcSpace.kc t tc]
    exact closure_mono inter_subset_left

end PiBase
