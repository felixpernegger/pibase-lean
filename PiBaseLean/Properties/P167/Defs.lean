module

public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Filter

universe u

namespace PiBase

/- 167. Sequentially discrete -/
class SeqDiscreteSpace (X : Type u) [TopologicalSpace X] : Prop where
  tendsto_constant : ∀ᵉ (s : ℕ → X) (x : X), Tendsto s atTop (𝓝 x) → ∀ᶠ n in atTop, s n = x

end PiBase
