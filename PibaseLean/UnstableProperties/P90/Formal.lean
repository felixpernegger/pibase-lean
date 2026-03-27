import PibaseLean.UnstableProperties.P90.Defs

namespace PiBase.Formal

abbrev P90 := AlexandrovDiscrete

class NP90 (X : Type*) [TopologicalSpace X] where
  not_p90 : ¬ P90 X

end PiBase.Formal
