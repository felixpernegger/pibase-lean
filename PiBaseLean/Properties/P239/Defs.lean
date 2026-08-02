module

public import Mathlib.Topology.Homotopy.Contractible
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

open Topology Filter

/- 239. Semilocally contractible -/
class SemilocallyContractibleSpace (X : Type u) [TopologicalSpace X] : Prop where
  contractible_nbhd (x : X) : ∃ s ∈ 𝓝 x, ∃ f : unitInterval → s → X,
    Continuous f ∧ f 0 = Subtype.val ∧ ∀ a b : s, f 1 a = f 1 b

end PiBase

namespace PiBase.Formal

def P239 : Property where
  toPred := SemilocallyContractibleSpace
  well_defined φ h := sorry

end PiBase.Formal
