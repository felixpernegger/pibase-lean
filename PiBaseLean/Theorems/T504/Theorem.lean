module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P92.Defs
public import PiBaseLean.Properties.P98.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T504: P92 (kω3Space) => P98 (kω1Space) -/
instance instkω1SpaceOfkω3Space (X : Type u)
    [TopologicalSpace X] [h : kω3Space X] :
    kω1Space X where
  k_omega :=
    let ⟨K, Km, Ku, Kc, _, hK⟩ := h.k_omega
    ⟨K, Km, Ku, Kc, hK⟩

end PiBase

namespace PiBase.Formal

theorem T504 : P92 ≤ P98 := fun X _ ↦ @instkω1SpaceOfkω3Space X _

end PiBase.Formal
