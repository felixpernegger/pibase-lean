import PibaseLean.UnstableProperties.P31.Defs

namespace PiBase.Formal

abbrev P31 := MetacompactSpace

class NP31 (X : Type*) [TopologicalSpace X] where
  not_p31 : ¬ P31 X

end PiBase.Formal
