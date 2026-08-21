module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P30.Lemmas

@[expose] public section

namespace PiBase.Formal

def P30 : Property := WellDefined.toProperty WellDefined.paracompactSpace

end PiBase.Formal
