module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P57.Bundled
public import PiBaseLean.Properties.P93.Bundled

@[expose] public section

universe u

open Filter Set

namespace PiBase

/-- Theorem T238: P57 (Countable) => P93 (LocallyCountableSpace)

The whole space is a countable neighbourhood of each of its points. -/
theorem instLocallyCountableSpaceOfCountable {X : Type u} [TopologicalSpace X] [Countable X] :
    LocallyCountableSpace X :=
  ⟨fun _ ↦ ⟨univ, univ_mem, countable_univ⟩⟩

end PiBase

namespace PiBase.Formal

theorem T238 : P57 ≤ P93 := fun X _ h ↦ @instLocallyCountableSpaceOfCountable X _ h

end PiBase.Formal
