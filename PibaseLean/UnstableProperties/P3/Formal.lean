import PibaseLean.Properties.P3.Defs

namespace PiBase.Formal

abbrev P3 := T2Space

class NP3 (X : Type*) [TopologicalSpace X] where
  not_p3 : ¬ P3 X

end PiBase.Formal
