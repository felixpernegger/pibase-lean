import PibaseLean.Properties.P39.Defs

namespace PiBase.Formal

abbrev P39 := HyperconnectedSpace

class NP39 (X : Type*) [TopologicalSpace X] where
  not_p39 : ¬ P39 X

end PiBase.Formal
