import PibaseLean.Properties.P41.Defs

namespace PiBase.Formal

abbrev P41 := LocallyConnectedSpace

class NP41 (X : Type*) [TopologicalSpace X] where
  not_p41 : ¬ P41 X

end PiBase.Formal
