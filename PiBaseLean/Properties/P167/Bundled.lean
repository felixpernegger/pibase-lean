module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P167.Lemmas

@[expose] public section

namespace PiBase.Formal

def P167 : Property := WellDefined.toProperty WellDefined.seqDiscreteSpace

end PiBase.Formal
