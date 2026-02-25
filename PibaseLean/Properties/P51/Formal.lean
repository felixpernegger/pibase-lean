import PibaseLean.Properties.P51.Defs

namespace PiBase.Formal

abbrev P51 := ScatteredSpace

class NP51 (X : Type*) [TopologicalSpace X] where
  not_p51 : ¬ P51 X

end PiBase.Formal
