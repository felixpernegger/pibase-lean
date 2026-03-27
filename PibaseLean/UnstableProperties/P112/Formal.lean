import PibaseLean.UnstableProperties.P112.Defs

namespace PiBase.Formal

abbrev P112 := TorontoSpace

class NP112 (X : Type*) [TopologicalSpace X] where
  not_p112 : ¬ P112 X

end PiBase.Formal
