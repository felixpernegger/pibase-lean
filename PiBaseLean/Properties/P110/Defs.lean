module

public import Mathlib.Data.Countable.Defs
public import Mathlib.Topology.Defs.Filter
public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter

universe u

namespace PiBase

open PiBase.AdditionalDefs

structure Development (X : Type u) [TopologicalSpace X] where
  idx : ℕ → Type u
  toCover : {n : ℕ} → (idx n) → Set X
  isOpen : ∀ᵉ (n : ℕ) (t : idx n), IsOpen (toCover t)
  isCover : ∀ᵉ (n : ℕ), ⋃ t : idx n, toCover t = univ
  isLocalBase (x : X) : HasBasis (𝓝 x) (fun _ ↦ True)  (fun n ↦ CoverStar (toCover (n := n)) x)

/- 110. Developable -/
class DevelopableSpace (X : Type u) [TopologicalSpace X] : Prop where
  developable : Nonempty (Development X)

end PiBase

namespace PiBase.Formal

def P110 : Property where
  toPred := DevelopableSpace
  well_defined φ h := sorry

end PiBase.Formal
