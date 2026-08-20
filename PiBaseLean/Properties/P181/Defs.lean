module

public import Mathlib.Data.Countable.Defs

@[expose] public section

namespace PiBase

/-- 181. Countably infinite -/
class CountablyInfinite (X : Type*) extends Countable X, Infinite X

end PiBase
