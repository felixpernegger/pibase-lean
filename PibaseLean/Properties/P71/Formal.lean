import PibaseLean.Properties.P71.Defs

namespace PiBase.Formal

abbrev P71 := SigmaRelativelyCompactSpace

class NP71 (X : Type*) [TopologicalSpace X] where
  not_p71 : ¬ P71 X

end PiBase.Formal
