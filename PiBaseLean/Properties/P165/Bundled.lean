module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P165.Lemmas

@[expose] public section

namespace PiBase.Formal

def P165 : Property := WellDefined.toProperty WellDefined.pseudonormalSpace

end PiBase.Formal
