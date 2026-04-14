module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P117.Defs
public import PiBaseLean.Properties.P118.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T34: P118 (HasSigmaLocallyFiniteKNetwork) => P117 (HasSigmaLocallyFiniteNetwork) -/
instance instHasSigmaLocallyFiniteNetworkOfHasSigmaLocallyFiniteKNetwork (X : Type u)
    [TopologicalSpace X] [h : HasSigmaLocallyFiniteKNetwork X] :
    HasSigmaLocallyFiniteNetwork X where
  ex_network :=
    let ⟨ι, f, hf, hf'⟩ := h.ex_network
    ⟨ι, f, hf, hf'.isNetwork⟩

end PiBase

namespace PiBase.Formal

theorem T34 : P118 ≤ P117 := fun X _ ↦ @instHasSigmaLocallyFiniteNetworkOfHasSigmaLocallyFiniteKNetwork X _

end PiBase.Formal
