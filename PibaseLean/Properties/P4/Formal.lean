import PibaseLean.Properties.P4.Defs

namespace PiBase.Formal

abbrev P4 := T2Space

class NP4 (X : Type*) [TopologicalSpace X] where
  not_p4 : ¬ P4 X

end PiBase.Formal
