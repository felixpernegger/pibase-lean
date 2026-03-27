import PibaseLean.UnstableProperties.P94.Defs

namespace PiBase.Formal

abbrev P94 := LocallyFiniteSpace

class NP94 (X : Type*) [TopologicalSpace X] where
  not_p94 : ¬ P94 X

end PiBase.Formal
