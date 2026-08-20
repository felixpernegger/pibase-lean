module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P79.Lemmas

@[expose] public section

namespace PiBase.Formal

def P79 : Property := WellDefined.toProperty WellDefined.sequentialSpace

end PiBase.Formal
