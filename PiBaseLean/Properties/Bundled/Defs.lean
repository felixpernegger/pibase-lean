import Mathlib.Topology.Homeomorph.Defs

namespace PiBase.Formal

structure Property where
  toPred (X : Type u) [TopologicalSpace X] : Prop
  well_defined' {X Y : Type u} [TopologicalSpace X] [TopologicalSpace Y]
    (φ : X ≃ₜ Y) (h : toPred X) : toPred Y

namespace Property

instance : DFunLike Property (Type u)
    (fun (X : Type u) => [TopologicalSpace X] → Prop) where
  coe := toPred
  coe_injective' := fun u v h =>
    (Property.mk.injEq u.toPred u.well_defined' v.toPred v.well_defined') ▸ h

theorem toPred_injective : toPred.Injective := DFunLike.coe_injective

theorem well_defined (p : Property) {X Y : Type u} [TopologicalSpace X] [TopologicalSpace Y]
    (φ : X ≃ₜ Y) : p X ↔ p Y := ⟨fun h => p.well_defined' φ h, fun h => p.well_defined' φ.symm h⟩

end Property

end PiBase.Formal
