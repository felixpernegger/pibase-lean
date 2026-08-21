module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P101.Lemmas

@[expose] public section

namespace PiBase.Formal

def P101 : Property := WellDefined.toProperty WellDefined.hasClosedRetract

end PiBase.Formal
