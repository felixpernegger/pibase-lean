import Mathlib.Topology.Compactness.CountablyCompact
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 103. Stronlgy KC Space -/
class StronglyKcSpace (X : Type*) [TopologicalSpace X] : Prop where
  countablycompact_closed : ∀ s : Set X, IsCountablyCompact s → IsClosed s

end PiBase

namespace PiBase.Formal

def P103 : Property where
  toPred := StronglyKcSpace
  well_defined' φ h := by
    refine ⟨fun s Ks ↦ ?_⟩
    simpa only [Homeomorph.isClosed_image] using h.countablycompact_closed (φ.symm '' s)
      (Ks.image φ.symm.continuous)

end PiBase.Formal
