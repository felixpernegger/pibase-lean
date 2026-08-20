module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P47.Lemmas

@[expose] public section

namespace PiBase.Formal

def P47 : Property := WellDefined.toProperty WellDefined.totallyDisconnectedSpace

end PiBase.Formal
