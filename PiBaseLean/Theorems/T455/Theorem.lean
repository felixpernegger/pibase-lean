import PiBaseLean.Properties.P181.Defs

universe u

namespace PiBase

--TODO: When negations of properties are properly implemented, maybe redo this
/-- Theorem 455: a countably infinite space is infinite -/
instance instCountablyInfiniteOfCountableOfInfinite {X : Type u} [Countable X] [Infinite X] :
    CountablyInfinite X := by tauto

end PiBase
