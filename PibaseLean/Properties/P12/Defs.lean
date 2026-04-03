import Mathlib.Topology.Separation.CompletelyRegular
namespace PiBase

/- 12. Completely regular -/
#check CompletelyRegularSpace

end PiBase

namespace PiBase.Formal

abbrev P12 := CompletelyRegularSpace

class NP12 (X : Type*) [TopologicalSpace X] where
  not_p12 : ¬ P12 X

end PiBase.Formal
