module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P227.Lemmas

@[expose] public section

namespace PiBase.Formal

def P227 : Property := WellDefined.toProperty WellDefined.hasClosedDiscreteSubsetCardContinuum

end PiBase.Formal
