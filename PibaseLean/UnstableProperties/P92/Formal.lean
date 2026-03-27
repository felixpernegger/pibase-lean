import PibaseLean.UnstableProperties.P92.Defs

namespace PiBase.Formal

abbrev P92 := kωSpace

class NP92 (X : Type*) [TopologicalSpace X] where
  not_p92 : ¬ P92 X

end PiBase.Formal
