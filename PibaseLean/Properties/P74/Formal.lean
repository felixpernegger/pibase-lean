import PibaseLean.Properties.P74.Defs

namespace PiBase.Formal

abbrev P74 := CosmicSpace

class NP74 (X : Type*) [TopologicalSpace X] where
  not_p74 : ¬ P74 X

end PiBase.Formal
