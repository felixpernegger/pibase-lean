import PibaseLean.UnstableProperties.P32.Defs

namespace PiBase.Formal

universe u

abbrev P32 (X : Type u) [TopologicalSpace X] := CountablyParacompactSpace X

class NP32 (X : Type*) [TopologicalSpace X] where
  not_p32 : ¬ P32 X

end PiBase.Formal
