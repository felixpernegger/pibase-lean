import PibaseLean.Properties.P20.Defs

namespace PiBase.Formal

abbrev P20 := SeqCompactSpace

class NP20 (X : Type*) [TopologicalSpace X] where
  not_p20 : ¬ P20 X

end PiBase.Formal
