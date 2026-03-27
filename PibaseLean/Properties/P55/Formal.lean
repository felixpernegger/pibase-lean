import PibaseLean.Properties.P55.Defs

namespace PiBase.Formal

abbrev P55 := TopologicalSpace.IsCompletelyMetrizableSpace

class NP55 (X : Type*) [TopologicalSpace X] where
  not_p55 : ¬ P55 X

end PiBase.Formal
