import PibaseLean.Properties.P97.Defs

namespace PiBase.Formal

abbrev P97 := EmbeddableInR

class NP97 (X : Type*) [TopologicalSpace X] where
  not_p97 : ¬ P97 X

end PiBase.Formal
