import PibaseLean.Properties.P62.Defs

namespace PiBase.Formal

abbrev P62 := WeaklyLindelofSpace

class NP62 (X : Type*) [TopologicalSpace X] where
  not_p62 : ¬ P62 X

end PiBase.Formal
