module

public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 244. Has countable π-character -/
class HasCountablePiCharacter (X : Type*) [TopologicalSpace X] : Prop where
  ex_localPiBase (x : X) : ∃ s : Set (Set X), s.Countable ∧ IsLocalPiBase x s

end PiBase

namespace PiBase.Formal

def P244 : Property where
  toPred := HasCountablePiCharacter
  well_defined φ h := sorry

end PiBase.Formal
