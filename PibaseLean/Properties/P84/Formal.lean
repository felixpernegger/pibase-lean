import PibaseLean.Properties.P84.Defs

namespace PiBase.Formal

abbrev P84 := LocallyT2Space

class NP84 (X : Type*) [TopologicalSpace X] where
  not_p84 : ¬ P84 X

end PiBase.Formal
