module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P39.Defs
public import PiBaseLean.Properties.P137.Defs
public import PiBaseLean.Properties.P192.Defs
public import PiBaseLean.Properties.P201.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T594: P192 (QuasiSober) + P39 (PreirreducibleSpace) +
P137 (¬IsEmpty) => P201 (HasGenericPoint) -/
instance instHasGenericPointOfQuasiSoberOfPreirreducibleSpaceOfNonempty (X : Type u)
    [TopologicalSpace X] [h : QuasiSober X] [h' : PreirreducibleSpace X] [h'' : Nonempty X] :
    HasGenericPoint X where
  ex_generic_point := by
    have := IsIrreducible.isGenericPoint_genericPoint_closure
      ⟨univ_nonempty, h'.isPreirreducible_univ⟩
    rw [closure_univ] at this
    exact .intro (IsIrreducible.genericPoint ⟨univ_nonempty, h'.isPreirreducible_univ⟩) this

end PiBase

namespace PiBase.Formal

theorem T594 : P192 ⊓ P39 ⊓ P137ᶜ ≤ P201 :=
  fun X _ ⟨⟨h1, h2⟩, h3⟩ ↦
    have : Nonempty X := not_isEmpty_iff.mp h3
    @instHasGenericPointOfQuasiSoberOfPreirreducibleSpaceOfNonempty X _ h1 h2 ‹_›

end PiBase.Formal
