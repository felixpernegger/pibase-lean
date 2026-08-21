module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P127.Lemmas

@[expose] public section

namespace PiBase.Formal

def P127 : Property := WellDefined.toProperty WellDefined.dowkerSpace

end PiBase.Formal
