module

public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace PiBase.AdditionalDefs

universe u

namespace PiBase

/- 194. Submetacompact -/
class SubmetacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  ex_seq : ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → ⋃ a, s a = univ →
      ∃ (ω : ℕ → Type u) (t : (n : ℕ) → ω n → Set X), (∀ n : ℕ, (∀ (a : ω n), IsOpen (t n a)) ∧
        ⋃ a, t n a = univ ∧ ∀ (b : ω n), ∃ (a : α), t n b ⊆ s a) ∧ ∀ x, ∃ n, PointFiniteAt (t n) x

end PiBase

namespace PiBase.Formal

def P194 : Property where
  toPred := SubmetacompactSpace
  well_defined φ h := sorry

end PiBase.Formal
