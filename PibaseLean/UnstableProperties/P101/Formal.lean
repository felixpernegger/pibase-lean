import PibaseLean.Properties.P101.Defs

namespace PiBase.Formal

abbrev P101 := HasClosedRetract

class NP101 (X : Type*) [TopologicalSpace X] where
  not_p101 : ¬ P101 X

end PiBase.Formal
