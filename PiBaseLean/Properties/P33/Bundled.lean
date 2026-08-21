module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P33.Lemmas

@[expose] public section

namespace PiBase.Formal

def P33 : Property := WellDefined.toProperty WellDefined.countablyMetacompactSpace

end PiBase.Formal
