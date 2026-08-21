module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P169.Lemmas

@[expose] public section

namespace PiBase.Formal

def P169 : Property := WellDefined.toProperty WellDefined.semiT2Space

end PiBase.Formal
