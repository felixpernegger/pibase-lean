module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P22.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.pseudocompactSpace : WellDefined PseudocompactSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro f hf
    have hfφ : Continuous (f ∘ φ) := hf.comp φ.continuous
    obtain ⟨hBddBelow, hBddAbove⟩ := h.pseudocompact (f ∘ φ) hfφ
    have hRange : range (f ∘ φ) = range f := by
      rw [Set.range_comp, EquivLike.range_eq_univ, Set.image_univ]
    exact ⟨hRange ▸ hBddBelow, hRange ▸ hBddAbove⟩

end PiBase
