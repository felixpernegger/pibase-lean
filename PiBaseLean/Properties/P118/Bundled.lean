module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P118.Lemmas

@[expose] public section

namespace PiBase.Formal

def P118 : Property := WellDefined.toProperty WellDefined.hasSigmaLocallyFiniteKNetwork

end PiBase.Formal
