module

public import Mathlib.Topology.Homeomorph.Defs

@[expose] public section

namespace PiBase.Formal

/-- Formally, we use the `Property` structure to encode properties of topological functions,
which consist of the property in question and
a proof that it is being preserved under homeomorphism. -/
structure Property where
  /- The predicate which is being encoded -/
  toPred (X : Type u) [TopologicalSpace X] : Prop
  /- The property is preserved under homeomorphisms. -/
  well_defined {X Y : Type u} [TopologicalSpace X] [TopologicalSpace Y]
    (φ : X ≃ₜ Y) (h : toPred X) : toPred Y

namespace Property

instance : DFunLike Property (Type u)
    (fun (X : Type u) => [TopologicalSpace X] → Prop) where
  coe := toPred
  coe_injective' := fun u v h =>
    (Property.mk.injEq u.toPred u.well_defined v.toPred v.well_defined) ▸ h

theorem toPred_injective : toPred.Injective := DFunLike.coe_injective

/-- For two homeomorphic spaces `X`, `Y`, if `p` of type `Property` ,
`p X` and `p Y` are equivalent. -/
theorem well_defined_of_property (p : Property) {X Y : Type u}
    [TopologicalSpace X] [TopologicalSpace Y]
    (φ : X ≃ₜ Y) : p X ↔ p Y := ⟨fun h => p.well_defined φ h, fun h => p.well_defined φ.symm h⟩

end Property

end PiBase.Formal
