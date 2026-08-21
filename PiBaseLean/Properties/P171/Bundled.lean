module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P171.Lemmas

@[expose] public section

namespace PiBase.Formal

def P171 : Property := WellDefined.toProperty WellDefined.k2T2Space

end PiBase.Formal
