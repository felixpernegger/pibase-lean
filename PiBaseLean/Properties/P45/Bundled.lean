module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P45.Lemmas

@[expose] public section

namespace PiBase.Formal

def P45 : Property := WellDefined.toProperty WellDefined.hasDispersionPoint

end PiBase.Formal
