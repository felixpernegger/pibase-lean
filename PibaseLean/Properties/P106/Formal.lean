import PibaseLean.Properties.P106.Defs

namespace PiBase.Formal

abbrev P106 := HasGδDiagonal

class NP106 (X : Type*) [TopologicalSpace X] where
  not_p106 : ¬ P106 X

end PiBase.Formal
