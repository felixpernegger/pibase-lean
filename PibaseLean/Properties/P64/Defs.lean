import Mathlib.Topology.Defs.Basic

namespace PiBase

/- 64. Baire -/
#check BaireSpace

end PiBase

namespace PiBase.Formal

abbrev P64 := BaireSpace

class NP64 (X : Type*) [TopologicalSpace X] where
  not_p64 : ¬ P64 X

end PiBase.Formal
