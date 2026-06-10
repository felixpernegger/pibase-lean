module

public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 243. Has countable π-weight -/
class HasCountablePiWeight (X : Type*) [TopologicalSpace X] : Prop where
  ex_piBase : ∃ s : Set (Set X), s.Countable ∧ IsPiBase s

end PiBase

namespace PiBase.Formal

def P243 : Property where
  toPred := HasCountablePiWeight
  well_defined φ h := sorry

end PiBase.Formal
