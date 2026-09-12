module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P58.Bundled
public import PiBaseLean.Properties.P65.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T138: P65 (CardEqContinuum) => P58ᶜ (not CardLtContinuum)

A cardinal is not both equal to and less than `𝔠`. No topology is involved. -/
theorem instNotCardLtContinuumOfCardEqContinuum {X : Type u} [h : CardEqContinuum X] :
    ¬ CardLtContinuum X :=
  fun h' ↦ absurd h.card_eq h'.card_lt.ne

end PiBase

namespace PiBase.Formal

theorem T138 : P65 ≤ P58ᶜ := fun X _ h ↦ @instNotCardLtContinuumOfCardEqContinuum X h

end PiBase.Formal
