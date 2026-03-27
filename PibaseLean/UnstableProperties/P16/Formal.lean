import PibaseLean.Properties.P16.Defs

namespace PiBase.Formal

abbrev P16 := CompactSpace

class NP16 (X : Type*) [TopologicalSpace X] where
  not_p16 : ¬ P16 X

end PiBase.Formal
