module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P87.Defs
public import PiBaseLean.Properties.P187.Defs

@[expose] public section

universe u

namespace PiBase

/- 186. Embeds in a topological W-group -/
class EmbedsInTopologicalWGroupSpace (X : Type u) [TopologicalSpace X] : Prop where
  embeds_in_topological_w_group : ∃ (Y : Type u) (_ : TopologicalSpace Y) (f : X → Y),
    WSpace Y ∧ HasGroupTopology Y ∧ Topology.IsEmbedding f

end PiBase

namespace PiBase.Formal

def P186 : Property where
  toPred := EmbedsInTopologicalWGroupSpace
  well_defined φ h := sorry

end PiBase.Formal
