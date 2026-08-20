module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P115.Lemmas

@[expose] public section

namespace PiBase.Formal

def P115 : Property := WellDefined.toProperty WellDefined.subparacompactSpace

end PiBase.Formal
