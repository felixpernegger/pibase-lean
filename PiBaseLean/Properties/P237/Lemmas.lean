module

public import PiBaseLean.Properties.P236.Lemmas
public import PiBaseLean.Properties.P237.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.topologicalNManifoldWithBoundary :
    WellDefined TopologicalNManifoldWithBoundary :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    let hT2 : T2Space _ := φ.t2Space
    let hSC : SecondCountableTopology _ := φ.symm.secondCountableTopology
    let hL : LocallyNEuclideanHalfSpace _ :=
      WellDefined.locallyNEuclideanHalfSpace.homeo φ h.toLocallyNEuclideanHalfSpace
    @TopologicalNManifoldWithBoundary.mk _ _ hSC hT2 hL

end PiBase
