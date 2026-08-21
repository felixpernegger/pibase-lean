module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P163.Bundled
public import PiBaseLean.Properties.P58.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem 68: < 𝔠 implies ≤ 𝔠 -/
instance instCardLeContinuumOfCardLtContinuum {X : Type u} [h : CardLtContinuum X] :
    CardLeContinuum X where
  card_le := le_of_lt CardLtContinuum.card_lt

end PiBase

namespace PiBase.Formal

theorem T68 : P58 ≤ P163 := fun X _ ↦ @instCardLeContinuumOfCardLtContinuum X

end PiBase.Formal
