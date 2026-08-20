module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P152.Lemmas

@[expose] public section

namespace PiBase.Formal

def P152 : Property := WellDefined.toProperty WellDefined.markovRothbergerSpace

end PiBase.Formal
