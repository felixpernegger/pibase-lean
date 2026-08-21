module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P199.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.contractibleSpace : WellDefined ContractibleSpace :=
  fun {_ _} _ _ hXY _ =>
    let φ := hXY.some
    φ.symm.contractibleSpace

end PiBase
