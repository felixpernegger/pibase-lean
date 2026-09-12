module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P2.Bundled
public import PiBaseLean.Properties.P99.Bundled

@[expose] public section

universe u

open Set Filter Topology

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- Theorem T226: P99 ≤ P2

If `x ⤳ y` then the sequence constant at `x` converges both to `y` and to `x`, so uniqueness
of sequential limits gives `x = y`. -/
theorem instT1SpaceOfUsSpace [h : UsSpace X] : T1Space X := by
  refine t1Space_iff_specializes_imp_eq.2 fun x y hxy ↦ ?_
  have hc : Tendsto (fun _ : ℕ ↦ x) atTop (𝓝 y) := by
    rw [Tendsto, Filter.map_const]; exact specializes_iff_pure.1 hxy
  exact (h.us (fun _ ↦ x) y x hc tendsto_const_nhds).symm

end PiBase

namespace PiBase.Formal

theorem T226 : P99 ≤ P2 := fun X _ h ↦ @instT1SpaceOfUsSpace X _ h

end PiBase.Formal
