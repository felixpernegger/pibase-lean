module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P145.Lemmas

@[expose] public section

namespace PiBase.Formal

def P145 : Property := WellDefined.toProperty WellDefined.stronglyParacompactSpace

end PiBase.Formal
