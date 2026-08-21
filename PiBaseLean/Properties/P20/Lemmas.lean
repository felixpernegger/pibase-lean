module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P20.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.seqCompactSpace : WellDefined SeqCompactSpace :=
  fun {X Y} _ _ φ _ => by
    constructor
    convert IsSeqCompact.range φ.some.continuous.seqContinuous
    simp only [EquivLike.range_eq_univ]

theorem Homeomorph.seqCompactSpace [SeqCompactSpace X] (f : X ≃ₜ Y) : SeqCompactSpace Y := by
  constructor
  convert IsSeqCompact.range f.continuous.seqContinuous
  simp only [EquivLike.range_eq_univ]

end PiBase
