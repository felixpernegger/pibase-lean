module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P86.Lemmas

@[expose] public section

namespace PiBase.Formal

def P86 : Property := WellDefined.toProperty WellDefined.homogeneousSpace

end PiBase.Formal
