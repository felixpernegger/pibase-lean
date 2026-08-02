module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 243. Has countable π-weight -/
class HasCountablePiWeight (X : Type u) [TopologicalSpace X] : Prop where
  countable_pi_base : ∃ s : Set (Set X), IsPiBase s

end PiBase

namespace PiBase.Formal

def P243 : Property where
  toPred := HasCountablePiWeight
  well_defined φ h := sorry

end PiBase.Formal
