import PibaseLean.Properties.P23.Defs

variable (X : Type*) [TopologicalSpace X]

namespace PiBase.Formal

abbrev P23 := WeaklyLocallyCompact

class NP23 (X : Type*) [TopologicalSpace X] where
  not_p23 : ¬ P23 X

end PiBase.Formal
