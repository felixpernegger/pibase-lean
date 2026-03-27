import PibaseLean.UnstableProperties.P49.Defs

namespace PiBase.Formal

abbrev P49 := ExtremallyDisconnected

class NP49 (X : Type*) [TopologicalSpace X] where
  not_p49 : ¬ P49 X

end PiBase.Formal
