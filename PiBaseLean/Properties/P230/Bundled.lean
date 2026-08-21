module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P230.Lemmas

@[expose] public section

namespace PiBase.Formal

def P230 : Property := WellDefined.toProperty WellDefined.locallySimplyConnectedSpace

end PiBase.Formal
