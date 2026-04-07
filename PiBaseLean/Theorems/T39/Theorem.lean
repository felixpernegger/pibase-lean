module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P37.Defs
public import PiBaseLean.Properties.P38.Defs

@[expose] public section

open Topology Set Function

namespace PiBase

/- Theorem 39, injectively path connected
implies (pre-) path connected -/
instance instInjPathConnectedSpaceOfPrePathConnectedSpace
    {X : Type*} [TopologicalSpace X] [h : InjPathConnectedSpace X] :
    PrePathConnectedSpace X where
  joined x y :=
    (eq_or_ne x y).elim (fun xy => xy ▸ Joined.refl x)
      (fun xy => ((h.joined xy) (mem_univ x) (mem_univ y)).nonempty)

end PiBase

namespace PiBase.Formal

theorem T39 : P38 ≤ P37 := @instInjPathConnectedSpaceOfPrePathConnectedSpace

end PiBase.Formal
