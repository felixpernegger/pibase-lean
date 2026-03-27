import PibaseLean.UnstableProperties.P93.Defs

namespace PiBase.Formal

abbrev P93 := LocallyCountableSpace

class NP93 (X : Type*) [TopologicalSpace X] where
  not_p93 : ¬ P93 X

end PiBase.Formal
