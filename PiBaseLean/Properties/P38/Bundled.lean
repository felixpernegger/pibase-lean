module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P38.Lemmas

@[expose] public section

namespace PiBase.Formal

def P38 : Property := WellDefined.toProperty WellDefined.injPathConnectedSpace

end PiBase.Formal
