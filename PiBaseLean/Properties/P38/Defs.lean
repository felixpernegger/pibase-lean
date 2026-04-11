module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Function

namespace PiBase

open PiBase.AdditionalDefs

/- 38. Injectively path connected -/
class InjPathConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  joined : IsInjPathConnected (Set.univ (α := X))

end PiBase

namespace PiBase.Formal

def P38 : Property where
  toPred := InjPathConnectedSpace
  well_defined φ h := sorry

end PiBase.Formal
