module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P203.Lemmas

@[expose] public section

namespace PiBase.Formal

def P203 : Property := WellDefined.toProperty WellDefined.almostDiscreteSpace

end PiBase.Formal
