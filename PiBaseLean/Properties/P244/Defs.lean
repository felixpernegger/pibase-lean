module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

open Topology Filter

/- 244. Has countable π-character -/
class HasCountablePiCharacter (X : Type u) [TopologicalSpace X] : Prop where
  countable_local_pi_base (x : X) : ∃ s : Set (Set X), s.Countable ∧ ∀ U ∈ 𝓝 x, ∃ t ∈ s, t ⊆ U

end PiBase

namespace PiBase.Formal

def P244 : Property where
  toPred := HasCountablePiCharacter
  well_defined φ h := sorry

end PiBase.Formal
