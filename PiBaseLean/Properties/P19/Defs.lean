import Mathlib.Topology.Compactness.CountablyCompact

namespace PiBase

/- 19. Countably compact -/
#check CountablyCompactSpace

end PiBase

namespace PiBase.Formal

abbrev P19 := CountablyCompactSpace

class NP19 (X : Type*) [TopologicalSpace X] where
  not_p19 : ¬ P19 X

end PiBase.Formal
