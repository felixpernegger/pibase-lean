module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P32.Lemmas

@[expose] public section

namespace PiBase.Formal

def P32 : Property := WellDefined.toProperty WellDefined.countablyParacompactSpace

end PiBase.Formal
