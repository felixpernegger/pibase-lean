module

public import Mathlib.Topology.Compactness.Lindelof
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 131. Hereditarily Lindelöf space -/
#check HereditarilyLindelofSpace

end PiBase

namespace PiBase.Formal

def P131 : Property where
  toPred := HereditarilyLindelofSpace
  well_defined φ _ := by
    refine ⟨fun s _ ↦ ?_⟩
    convert (HereditarilyLindelofSpace.isLindelof (φ ⁻¹' s)).image φ.continuous
    simp only [Homeomorph.image_preimage]

end PiBase.Formal
