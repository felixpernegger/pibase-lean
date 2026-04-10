module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P16.Defs
public import PiBaseLean.Properties.P78.Defs
public import PiBaseLean.Properties.P136.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T303: P136 (AnticompactSpace) + P16 (CompactSpace) => P78 (Finite) -/
instance instFiniteOfAnticompactSpaceOfCompactSpace (X : Type u)
    [TopologicalSpace X] [h : AnticompactSpace X] [h' : CompactSpace X] :
    Finite X := finite_univ_iff.mp <| h.compact_finite univ h'.isCompact_univ

end PiBase

namespace PiBase.Formal

theorem T303 : P136 ⊓ P16 ≤ P78 := fun X _ ⟨h1, h2⟩ ↦
  @instFiniteOfAnticompactSpaceOfCompactSpace X _ h1 h2

end PiBase.Formal
