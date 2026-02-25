import PibaseLean.Properties.P88.Defs

namespace PiBase.Formal

abbrev P88 := CollectionwiseNormalSpace

class NP88 (X : Type*) [TopologicalSpace X] where
  not_p88 : ¬ P88 X

end PiBase.Formal
