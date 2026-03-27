import PibaseLean.Properties.P43.Defs

variable (X : Type*) [TopologicalSpace X]

namespace PiBase.Formal

abbrev P43 := LocallyInjPathConnectedSpace

class NP43 (X : Type*) [TopologicalSpace X] where
  not_p43 := ¬ P43 X

end PiBase.Formal
