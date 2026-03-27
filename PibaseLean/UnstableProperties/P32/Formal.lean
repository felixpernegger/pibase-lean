import PibaseLean.UnstableProperties.P32.Defs

namespace PiBase.Formal

abbrev P32 := CountablyParacompactSpace

class NP32 (X : Type*) [TopologicalSpace X] where
  not_p32 : ¬ P32 X

end PiBase.Formal
