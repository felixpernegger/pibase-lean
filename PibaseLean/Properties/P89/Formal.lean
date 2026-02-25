import PibaseLean.Properties.P89.Defs

namespace PiBase.Formal

abbrev P89 := FixedPointSpace

class NP89 (X : Type*) [TopologicalSpace X] where
  not_p89 : ¬ P89 X

end PiBase.Formal
