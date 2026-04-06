import Mathlib.Topology.Sets.Opens
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 109. Monotonically normal -/
class MonotonicallyNormalSpace (X : Type*) [TopologicalSpace X] : Prop extends T1Space X where
  monotonically_normal : ∃ μ : (x : X) → (s : Opens X) → (hs : ↑s ∈ 𝓝 x) → Opens X,
    ∀ (x : X) (s : Opens X) (hs : ↑s ∈ 𝓝 x), ↑s ∈ 𝓝 x → ↑(μ x s hs) ∈ 𝓝 x ∧
      ∀ (x y : X) (u v : Opens X) (hu : ↑u ∈ 𝓝 x) (hv : ↑v ∈ 𝓝 y),
        (↑(μ x u hu) : Set X) ∩ ↑(μ y v hv) ≠ ∅ → ↑v ∈ 𝓝 x ∨ ↑u ∈ 𝓝 y

end PiBase

namespace PiBase.Formal

def P109 : Property where
  toPred := MonotonicallyNormalSpace
  well_defined' φ h := sorry

end PiBase.Formal
