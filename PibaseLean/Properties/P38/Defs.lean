import PibaseLean.AdditionalDefs

open Function

namespace PiBase

/- 38. Injectively path connected -/
class InjPathConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  joined : IsInjPathConnected

end PiBase

variable (X : Type*) [TopologicalSpace X]

namespace PiBase.Formal

abbrev P38 := InjPathConnectedSpace

class NP38 (X : Type*) [TopologicalSpace X] where
  not_p38 : ¬ P38 X

end PiBase.Formal
