module

public import PiBaseLean.AdditionalDefs.Meta
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Data.Set.Countable
public import Mathlib.Data.Set.Image
public import Mathlib.Topology.Defs.Filter

@[expose] public section

universe u

namespace PiBase

open Topology Filter
open scoped Topology

/- 244. Has countable π-character -/
class HasCountablePiCharacter (X : Type u) [TopologicalSpace X] : Prop where
  countable_local_pi_base (x : X) : ∃ s : Set (Set X),
    ∅ ∉ s ∧ (∀ a ∈ s, IsOpen a) ∧ s.Countable ∧ ∀ U ∈ 𝓝 x, ∃ t ∈ s, t ⊆ U

end PiBase
