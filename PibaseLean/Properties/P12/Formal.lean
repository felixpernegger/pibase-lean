import PibaseLean.Properties.P12.Defs

namespace PiBase.Formal

abbrev P12 := CompletelyRegularSpace

class NP12 (X : Type*) [TopologicalSpace X] where
  not_p12 : ¬ P12 X

end PiBase.Formal
