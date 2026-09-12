module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P2.Bundled
public import PiBaseLean.Properties.P86.Bundled
public import PiBaseLean.Properties.P107.Bundled

@[expose] public section

universe u

open Set

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- Theorem T633: P86 ⊓ P107 ≤ P2

If `{p}` is closed, homogeneity carries it to `{x}` by a homeomorphism for each `x`, and
homeomorphisms are closed maps, so every singleton is closed. -/
theorem instT1SpaceOfHomogeneousSpaceOfHasClosedPoint
    [hh : HomogeneousSpace X] [hc : HasClosedPoint X] : T1Space X := by
  obtain ⟨p, hcp⟩ := hc.has_closed_point
  refine ⟨fun x ↦ ?_⟩
  obtain ⟨f, hf⟩ := hh.homogeneous p x
  simpa [hf] using f.isClosedMap _ hcp

end PiBase

namespace PiBase.Formal

theorem T633 : P86 ⊓ P107 ≤ P2 := fun X _ ⟨h1, h2⟩ ↦
  @instT1SpaceOfHomogeneousSpaceOfHasClosedPoint X _ h1 h2

end PiBase.Formal
