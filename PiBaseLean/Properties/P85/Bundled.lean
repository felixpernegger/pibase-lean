module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P85.Lemmas

@[expose] public section

namespace PiBase.Formal

def P85 : Property := WellDefined.toProperty WellDefined.basicallyDisconnectedSpace

end PiBase.Formal
