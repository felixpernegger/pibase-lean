import PibaseLean.UnstableProperties.P109.Defs

namespace PiBase.Formal

abbrev P109 := MonotonicallyNormalSpace

class NP109 (X : Type*) [TopologicalSpace X] where
  not_p109 : ¬ P109 X

end PiBase.Formal
