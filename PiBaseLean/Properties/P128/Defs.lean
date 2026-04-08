module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

universe u

namespace PiBase

/- 128. k-Lindelöf -/
class KLindelofSpace (X : Type u) [TopologicalSpace X] : Prop where
  ex_kSubcover {ι : Type u} {f : ι → Opens X} (h : IsKCover f) :
    ∃ (ω : Type u) (g : ω → Opens X), Countable ω ∧
      (⋃ i, (↑(g i) : Set X) = univ) ∧ range g ⊆ range f

end PiBase

namespace PiBase.Formal

def P128 : Property where
  toPred := KLindelofSpace
  well_defined φ h := sorry

end PiBase.Formal
