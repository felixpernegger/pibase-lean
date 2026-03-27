import PibaseLean.UnstableProperties.P87.Defs

namespace PiBase.Formal

abbrev P87 := HasGroupTopology

class NP87 (X : Type*) [TopologicalSpace X] where
  not_p87 : ¬ P87 X

end PiBase.Formal
