import PibaseLean.UnstableProperties.P33.Defs

namespace PiBase.Formal

abbrev P33 := CountablyMetacompactSpace

class NP33 (X : Type*) [TopologicalSpace X] where
  not_p33 : ¬ P33 X

end PiBase.Formal
