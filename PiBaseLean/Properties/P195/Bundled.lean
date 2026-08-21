module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P195.Lemmas

@[expose] public section

namespace PiBase.Formal

def P195 : Property := WellDefined.toProperty WellDefined.stoneSpace

end PiBase.Formal
