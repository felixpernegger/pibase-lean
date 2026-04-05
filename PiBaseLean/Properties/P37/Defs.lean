import Mathlib.Topology.Connected.PathConnected
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function

namespace PiBase

/- 37. Path connected
Note: Unlike Mathlib, we allow the space to be empty. -/
class PrePathConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  joined : ∀ x y : X, Joined x y

end PiBase

namespace PiBase.Formal

def P37 : Property where
  toPred := PrePathConnectedSpace
  well_defined' φ h := by
    refine ⟨fun x y ↦ (h.joined (φ.symm x) (φ.symm y)).elim fun p => ⟨?_⟩⟩
    convert p.map φ.continuous <;> simp only [Homeomorph.apply_symm_apply]

end PiBase.Formal
