import PibaseLean.UnstableProperties.P75.Defs

namespace PiBase.Formal

abbrev P75 := SpectralSpace

class NP75 (X : Type*) [TopologicalSpace X] where
  not_p75 : ¬ P75 X

end PiBase.Formal
