module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P107.Bundled
public import PiBaseLean.Properties.P137.Bundled
public import PiBaseLean.Properties.P2.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T630: P2 (T1Space) + P137ᶜ (Nonempty) => P107 (HasClosedPoint) -/
instance instHasClosedPointOfT1SpaceOfNonempty {X : Type u}
    [TopologicalSpace X] [h : T1Space X] [h' : Nonempty X] : HasClosedPoint X where
  has_closed_point := ⟨h'.some, T1Space.t1 h'.some⟩

end PiBase

namespace PiBase.Formal

theorem T630 : P2 ⊓ P137ᶜ ≤ P107 :=
  fun X _ ⟨h1, h2⟩ ↦ have : Nonempty X := not_isEmpty_iff.mp h2
    @instHasClosedPointOfT1SpaceOfNonempty X _ h1 ‹_›

end PiBase.Formal
