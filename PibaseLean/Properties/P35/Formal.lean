import PibaseLean.Properties.P35.Defs

namespace PiBase.Formal

abbrev P35 := FullyT4Space

class NP35 (X : Type*) [TopologicalSpace X] where
  not_p35 : ¬ P35 X

end PiBase.Formal
