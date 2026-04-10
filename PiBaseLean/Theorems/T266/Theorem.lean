module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P78.Defs
public import PiBaseLean.Properties.P94.Defs

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T266: P78 (Finite) => P94 (LocallyFiniteSpace) -/
instance instLocallyFiniteSpaceOfFinite (X : Type u)
    [TopologicalSpace X] [h : Finite X] :
    LocallyFiniteSpace X where
  locally_finite _ := ⟨univ, univ_mem, finite_univ⟩

end PiBase

namespace PiBase.Formal

theorem T266 : P78 ≤ P94 := fun X _ ↦ @instLocallyFiniteSpaceOfFinite X _

end PiBase.Formal
