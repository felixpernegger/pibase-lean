module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P92.Defs
public import PiBaseLean.Properties.P98.Defs
public import PiBaseLean.Properties.P170.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T505: P98 (kω1Space) + P170 (K1T2Space) => P92 (kω3Space) -/
instance instkω3SpaceOfkω1SpaceOfK1T2Space (X : Type u)
    [TopologicalSpace X] [h : kω1Space X] [h' : K1T2Space X] :
    kω3Space X where
  k_omega :=
    let ⟨K, Km, Ku, Kc, hK⟩ := h.k_omega
    ⟨K, Km, Ku, Kc, fun n ↦ h'.compact_t2 (K n) (Kc n), hK⟩

end PiBase

namespace PiBase.Formal

theorem T505 : P98 ⊓ P170 ≤ P92 := fun X _ ⟨h1, h2⟩ ↦ @instkω3SpaceOfkω1SpaceOfK1T2Space X _ h1 h2

end PiBase.Formal
