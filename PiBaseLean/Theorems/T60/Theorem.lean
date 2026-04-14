module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P140.Defs
public import PiBaseLean.Properties.P142.Defs
public import PiBaseLean.Properties.P170.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T60: P140 (CompactlyCoherentSpace) + P170 (K1T2Space) => P142 (K3Space) -/
instance instK3SpaceOfCompactlyCoherentSpaceOfK1T2Space (X : Type u)
    [TopologicalSpace X] [h : CompactlyCoherentSpace X] [h' : K1T2Space X] :
    K3Space X where
  isCoherentWith := by
    refine { isOpen_of_forall_induced := fun s hs ↦ ?_ }
    exact (h.isOpen_iff (A := s)).2 fun K hK ↦ hs K ⟨h'.compact_t2 K hK, hK⟩

end PiBase

namespace PiBase.Formal

theorem T60 : P140 ⊓ P170 ≤ P142 :=
  fun X _ ⟨h1, h2⟩ ↦ @instK3SpaceOfCompactlyCoherentSpaceOfK1T2Space X _ h1 h2

end PiBase.Formal
