import Mathlib.Data.Countable.Defs

namespace PiBase

/-- 181. Countably infinite -/
class CountablyInfinite (X : Type*) extends Countable X, Infinite X

end PiBase
