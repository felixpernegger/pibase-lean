module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

universe u

namespace PiBase

open scoped Topology

/- 244. Has countable π-character -/
class HasCountablePiCharacter (X : Type u) [TopologicalSpace X] : Prop where
  countable_local_pi_base (x : X) : ∃ s : Set (Set X),
    ∅ ∉ s ∧ (∀ a ∈ s, IsOpen a) ∧ s.Countable ∧ ∀ U ∈ 𝓝 x, ∃ t ∈ s, t ⊆ U

end PiBase
