module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P188.Lemmas

@[expose] public section

namespace PiBase.Formal

def P188 : Property := WellDefined.toProperty WellDefined.continuumSpace

end PiBase.Formal
