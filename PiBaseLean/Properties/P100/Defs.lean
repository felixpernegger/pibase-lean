import Mathlib.Topology.Compactness.Compact
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 100. KC Space -/
class KcSpace (X : Type*) [TopologicalSpace X] : Prop where
  kc : ∀ s : Set X, IsCompact s → IsClosed s

end PiBase

namespace PiBase.Formal

def P100 : Property where
  toPred := KcSpace
  well_defined' φ h := by
    refine ⟨fun s Ks ↦ ?_⟩
    simpa only [Homeomorph.isClosed_image] using h.kc (φ.symm '' s) (Ks.image φ.symm.continuous)

end PiBase.Formal
