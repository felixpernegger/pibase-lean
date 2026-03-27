import PibaseLean.Properties.P61.Defs

namespace PiBase.Formal

abbrev P61 := CozeroComplementedSpace

class NP61 (X : Type*) [TopologicalSpace X] where
  not_p61 : ¬ P61 X

end PiBase.Formal
