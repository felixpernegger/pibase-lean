import PibaseLean.Properties.P24.Defs

variable (X : Type*) [TopologicalSpace X]

namespace PiBase.Formal

abbrev P24 := WeaklyLocallyCompact

class NP24 (X : Type*) [TopologicalSpace X] where
  not_p24 : ¬ P24 X

end PiBase.Formal
