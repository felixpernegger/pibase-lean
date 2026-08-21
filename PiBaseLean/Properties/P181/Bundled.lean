module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P181.Lemmas

@[expose] public section

namespace PiBase.Formal

def P181 : Property := WellDefined.toProperty WellDefined.countablyInfinite

end PiBase.Formal
