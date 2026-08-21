module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P20.Lemmas

@[expose] public section

namespace PiBase.Formal

def P20 : Property := WellDefined.toProperty WellDefined.seqCompactSpace

end PiBase.Formal
