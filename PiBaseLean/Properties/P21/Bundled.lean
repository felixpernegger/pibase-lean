module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P21.Lemmas

@[expose] public section

namespace PiBase.Formal

def P21 : Property := WellDefined.toProperty WellDefined.weaklyCountablyCompact

end PiBase.Formal
