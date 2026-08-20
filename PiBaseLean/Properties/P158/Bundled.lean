module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P158.Lemmas

@[expose] public section

namespace PiBase.Formal

def P158 : Property := WellDefined.toProperty WellDefined.markovKRothbergerSpace

end PiBase.Formal
