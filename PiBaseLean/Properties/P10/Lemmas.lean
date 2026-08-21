module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P10.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.semiregularSpace : WellDefined SemiregularSpace :=
  fun {X Y} _ _ φ h => by
    rcases h.semiregular with ⟨B, hB, hR⟩
    refine ⟨Set.image φ.some '' B, hB.isQuotientMap φ.some.isQuotientMap φ.some.isOpenMap, ?_⟩
    rintro _ ⟨s, hs, rfl⟩
    unfold IsRegularOpen
    rw [← φ.some.image_closure, ← φ.some.image_interior, hR s hs]

theorem Homeomorph.semiregularSpace [SemiregularSpace X] (f : X ≃ₜ Y) : SemiregularSpace Y := by
  rcases SemiregularSpace.semiregular (X := X) with ⟨B, hB, hR⟩
  refine ⟨Set.image f '' B, hB.isQuotientMap f.isQuotientMap f.isOpenMap, ?_⟩
  rintro _ ⟨s, hs, rfl⟩
  unfold IsRegularOpen
  rw [← f.image_closure, ← f.image_interior, hR s hs]

end PiBase
