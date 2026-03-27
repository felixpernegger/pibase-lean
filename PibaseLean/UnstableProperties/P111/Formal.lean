import PibaseLean.UnstableProperties.P111.Defs

namespace PiBase.Formal

abbrev P111 := HemicompactSpace

class NP111 (X : Type*) [TopologicalSpace X] where
  not_p111 : ¬ P111 X

end PiBase.Formal
