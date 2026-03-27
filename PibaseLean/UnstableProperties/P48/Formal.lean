import PibaseLean.UnstableProperties.P48.Defs

namespace PiBase.Formal

abbrev P48 := TotallySeparatedSpace

class NP48 (X : Type*) [TopologicalSpace X] where
  not_p48 : ¬ P48 X

end PiBase.Formal
