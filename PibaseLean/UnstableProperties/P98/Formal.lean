import PibaseLean.UnstableProperties.P98.Defs

namespace PiBase.Formal

abbrev P98 := kωSpace'

class NP98 (X : Type*) [TopologicalSpace X] where
  not_p98 : ¬ P98 X

end PiBase.Formal
