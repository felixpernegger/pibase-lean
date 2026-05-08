module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P36.Defs
public import PiBaseLean.Properties.P39.Lemmas
public import PiBaseLean.Properties.P49.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T97: P49 (ExtremallyDisconnected) + P36 (PreconnectedSpace)
=> P39 (PreirreducibleSpace) -/
instance instPreirreducibleSpaceOfExtremallyDisconnectedOfPreconnectedSpace (X : Type u)
    [TopologicalSpace X] [h : ExtremallyDisconnected X] [h' : PreconnectedSpace X] :
    PreirreducibleSpace X := by
  apply (preirreducibleSpace_iff_open_dense X).mpr (fun s hs sn ↦ ?_)
  apply dense_iff_closure_eq.mpr
  cases preconnectedSpace_iff_clopen.mp h' (closure s) ⟨isClosed_closure, h.open_closure s hs⟩
  · simp_all
  · assumption

end PiBase

namespace PiBase.Formal

theorem T97 : P49 ⊓ P36 ≤ P39 :=
  fun X _ ⟨h1, h2⟩ ↦ @instPreirreducibleSpaceOfExtremallyDisconnectedOfPreconnectedSpace X _ h1 h2

end PiBase.Formal
