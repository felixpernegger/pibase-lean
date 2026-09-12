module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P52.Bundled
public import PiBaseLean.Properties.P86.Bundled
public import PiBaseLean.Properties.P139.Bundled

@[expose] public section

universe u

open Set

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- Theorem T209: P139 ⊓ P86 ≤ P52

If `p` is isolated, homogeneity carries `{p}` to `{x}` by a homeomorphism for each `x`, and
homeomorphisms are open maps, so every singleton is open. -/
theorem instDiscreteTopologyOfHasAnIsolatedPointOfHomogeneousSpace
    [hi : HasAnIsolatedPoint X] [hh : HomogeneousSpace X] : DiscreteTopology X := by
  obtain ⟨p, hop⟩ := hi.ex_isolated
  refine discreteTopology_iff_isOpen_singleton.2 fun x ↦ ?_
  obtain ⟨f, hf⟩ := hh.homogeneous p x
  simpa [hf] using f.isOpenMap _ hop

end PiBase

namespace PiBase.Formal

theorem T209 : P139 ⊓ P86 ≤ P52 := fun X _ ⟨h1, h2⟩ ↦
  @instDiscreteTopologyOfHasAnIsolatedPointOfHomogeneousSpace X _ h1 h2

end PiBase.Formal
