module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P36.Defs
public import PiBaseLean.Properties.P37.Defs
public import PiBaseLean.Properties.P233.Defs
public import PiBaseLean.Properties.P233.Lemmas

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T95: P36 (PreconnectedSpace) + P233 (HasOpenPathComponents) =>
P37 (PrepathConnectedSpace) -/
--TODO: golf
instance instPrepathconnectedSpaceOfPreconnectedSpaceOfHasOpenPathComponents (X : Type u)
    [TopologicalSpace X] [h : PreconnectedSpace X] [h' : HasOpenPathComponents X] :
      PrepathConnectedSpace X where
    joined x y := by
      apply (pathComponent_eq_iff_joined x y).mp
      have hx := preconnectedSpace_iff_clopen.mp h (pathComponent x) (h'.pathComponent_isClopen x)
      have hy := preconnectedSpace_iff_clopen.mp h (pathComponent y) (h'.pathComponent_isClopen y)
      simp_all [(pathComponent.nonempty x).ne_empty, (pathComponent.nonempty y).ne_empty]

end PiBase

namespace PiBase.Formal

theorem T95 : P36 ⊓ P233 ≤ P37 :=
  fun X _ ⟨h1, h2⟩ ↦ @instPrepathconnectedSpaceOfPreconnectedSpaceOfHasOpenPathComponents X _ h1 h2

end PiBase.Formal
