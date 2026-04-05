import Mathlib.Data.Countable.Defs
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/-- 181. Countably infinite -/
class CountablyInfinite (X : Type*) extends Countable X, Infinite X

end PiBase

namespace PiBase.Formal

def P181 : Property where
  toPred X := CountablyInfinite X
  well_defined' φ h := @CountablyInfinite.mk _ (.of_equiv _ φ.toEquiv)
    ((Equiv.infinite_iff φ.toEquiv).1 h.toInfinite)

end PiBase.Formal
