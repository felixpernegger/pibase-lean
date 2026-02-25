import PibaseLean.Properties.P83.Defs

namespace PiBase.Formal

abbrev P83 := MetaLindelofSpace

class NP83 (X : Type*) [TopologicalSpace X] where
  not_p83 : ¬ P83 X

end PiBase.Formal
