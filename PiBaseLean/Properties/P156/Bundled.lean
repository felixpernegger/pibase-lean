module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P156.Lemmas

@[expose] public section

namespace PiBase.Formal

def P156 : Property := WellDefined.toProperty WellDefined.kRothbergerSpace

end PiBase.Formal
