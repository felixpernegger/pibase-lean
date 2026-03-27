import PibaseLean.UnstableProperties.P80.Defs

namespace PiBase.Formal

abbrev P80 := FrechetUrysohnSpace

class NP80 (X : Type*) [TopologicalSpace X] where
  not_p80 : ¬ P80 X

end PiBase.Formal
