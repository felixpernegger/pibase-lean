import PibaseLean.UnstableProperties.P28.Defs

open TopologicalSpace

namespace PiBase.Formal

abbrev P28 := FirstCountableTopology

class NP28 (X : Type*) [TopologicalSpace X] where
  not_p28 : ¬ P28 X

end PiBase.Formal
