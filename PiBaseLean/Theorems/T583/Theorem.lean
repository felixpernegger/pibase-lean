import PiBaseLean.Properties.Bundled.Basic
import PiBaseLean.Properties.P199.Defs
import PiBaseLean.Properties.P200.Defs

namespace PiBase

/- Theorem 583: a contractible space is (pre-)simply connected -/
instance PreSimplyConnectedSpaceOfLocallySimplyConnectedSpace
    {X : Type*} [TopologicalSpace X] [ContractibleSpace X] :
    PreSimplyConnectedSpace X where
  presimplyconnected := Or.inr <| SimplyConnectedSpace.ofContractible X

end PiBase

namespace PiBase.Formal

theorem T583 : P199 ≤ P200 := @PreSimplyConnectedSpaceOfLocallySimplyConnectedSpace

end PiBase.Formal
