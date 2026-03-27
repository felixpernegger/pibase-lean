import PibaseLean.UnstableProperties.P64.Defs

namespace PiBase.Formal

abbrev P64 := BaireSpace

class NP64 (X : Type*) [TopologicalSpace X] where
  not_p64 : ¬ P64 X

end PiBase.Formal
