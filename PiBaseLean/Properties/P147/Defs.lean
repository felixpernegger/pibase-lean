module

public import Mathlib.Data.Countable.Defs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 147. P-space -/
class PSpace (X : Type u) [TopologicalSpace X] : Prop where
  inter_open (x : X) : ∀ {ι : Type} (f : ι → Set X),
    Countable ι → (∀ i : ι, IsOpen (f i)) → IsOpen (⋂ i : ι, f i)

end PiBase

namespace PiBase.Formal

def P147 : Property where
  toPred := PSpace
  well_defined φ h := sorry

end PiBase.Formal
