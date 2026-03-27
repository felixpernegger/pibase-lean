import PibaseLean.Properties.P108.Defs

namespace PiBase.Formal

abbrev P108 := HereditarilyCollectionwiseNormalSpace

class NP108 (X : Type*) [TopologicalSpace X] where
  not_p108 : ¬ P108 X

end PiBase.Formal
