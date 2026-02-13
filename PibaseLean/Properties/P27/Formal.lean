import PibaseLean.Properties.P27.Defs

open TopologicalSpace

namespace PiBase.Formal

abbrev P27 := SecondCountableTopology

class NP27 (X : Type*) [TopologicalSpace X] where
  not_p27 : ¬ P27 X

end PiBase.Formal
