import PibaseLean.UnstableProperties.P17.Defs

namespace PiBase.Formal

abbrev P17 := SigmaCompactSpace

class NP17 (X : Type*) [TopologicalSpace X] where
  not_p17 : ¬ P17 X

end PiBase.Formal
