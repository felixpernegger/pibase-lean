module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P189.Lemmas

@[expose] public section

namespace PiBase.Formal

def P189 : Property := WellDefined.toProperty WellDefined.sigmaConnectedSpace

end PiBase.Formal
