module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P103.Lemmas

@[expose] public section

namespace PiBase.Formal

def P103 : Property := WellDefined.toProperty WellDefined.stronglyKcSpace

end PiBase.Formal
