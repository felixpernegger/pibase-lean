module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P57.Bundled
public import PiBaseLean.Properties.P138.Bundled

@[expose] public section

universe u

open Set

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- Theorem T297: P138 ≤ P57

Constant maps are continuous, and distinct points give distinct constant maps, so `X` embeds
into `C(X, X)`. On the empty space there is nothing to prove. -/
theorem instCountableOfCountablyManyContinuousSelfMaps
    [h : CountablyManyContinuousSelfMaps X] : Countable X := by
  have := h.countable_self_maps
  rcases isEmpty_or_nonempty X with _ | hne
  · infer_instance
  · exact Function.Injective.countable (f := fun x ↦ ContinuousMap.const X x)
      fun a b hab ↦ by simpa using DFunLike.congr_fun hab (Classical.arbitrary X)

end PiBase

namespace PiBase.Formal

theorem T297 : P138 ≤ P57 := fun X _ h ↦ @instCountableOfCountablyManyContinuousSelfMaps X _ h

end PiBase.Formal
