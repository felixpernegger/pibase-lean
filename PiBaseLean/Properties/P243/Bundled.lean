module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P243.Lemmas

@[expose] public section

namespace PiBase.Formal

def P243 : Property := WellDefined.toProperty WellDefined.hasCountablePiWeight

end PiBase.Formal
