import Mathlib.Topology.Compactness.Compact
import PiBaseLean.Properties.Bundled.Basic
import PiBaseLean.Properties.P23.Defs
import PiBaseLean.Properties.P24.Defs
import PiBaseLean.Properties.P100.Defs

open Topology Set Function TopologicalSpace Filter

namespace PiBase

/- Theorem 81: A weakly locally compact KC space is
locally relatively compact. -/
instance instLocallyRelativelyCompactSpaceOfWeaklyLocallyCompactSpaceOfKc
    {X : Type*} [TopologicalSpace X] [h : WeaklyLocallyCompactSpace X] [h' : KcSpace X] :
    LocallyRelativelyCompactSpace X where
  locally_relatively_compact x := by
    obtain ⟨t, tc, xt⟩ := exists_compact_mem_nhds x
    apply hasBasis_self.mpr (fun r hr ↦ ⟨t ∩ r, inter_mem xt hr, ?_, inter_subset_right⟩)
    apply tc.of_isClosed_subset isClosed_closure
    nth_rw 2 [← closure_eq_iff_isClosed.mpr <| KcSpace.kc t tc]
    exact closure_mono inter_subset_left

end PiBase

namespace PiBase.Formal

theorem T81 : P23 ⊓ P100 ≤ P24 := fun X _ ↦ and_imp.2
  (@instLocallyRelativelyCompactSpaceOfWeaklyLocallyCompactSpaceOfKc X _)

end PiBase.Formal
