module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P196.Defs
public import PiBaseLean.Properties.P204.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T620: P196 (HereditarilyConnected) => P204 (¬HasACutPoint) -/
theorem not_HasACutPointOfHereditarilyConnected (X : Type u)
    [TopologicalSpace X] [h : HereditarilyConnected X] :
    ¬ HasACutPoint X := by
  intro h0
  obtain ⟨p, hp⟩ := h0.ex_cut
  exact hp <| h.subset_connected {p}ᶜ

end PiBase

namespace PiBase.Formal

theorem T620 : P196 ≤ P204ᶜ := fun X _ h ↦ @not_HasACutPointOfHereditarilyConnected X _ h

end PiBase.Formal
