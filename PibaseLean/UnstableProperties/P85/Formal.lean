import PibaseLean.UnstableProperties.P85.Defs

namespace PiBase.Formal

abbrev P85 := BasicallyDisconnectedSpace

class NP85 (X : Type*) [TopologicalSpace X] where
  not_p85 : ¬ P85 X

end PiBase.Formal
