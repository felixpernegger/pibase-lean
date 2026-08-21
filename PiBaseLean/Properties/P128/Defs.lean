module

public import PiBaseLean.AdditionalDefs.Cover

@[expose] public section

open Set TopologicalSpace

universe u

namespace PiBase

/- 128. k-Lindelöf -/
class KLindelofSpace (X : Type u) [TopologicalSpace X] : Prop where
  ex_kSubcover {ι : Type u} {f : ι → Opens X} (h : IsKCover f) :
    ∃ (ω : Type u) (g : ω → Opens X), Countable ω ∧
      IsKCover g ∧ range g ⊆ range f

end PiBase
