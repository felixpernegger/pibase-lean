module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P142.Lemmas

@[expose] public section

namespace PiBase.Formal

def P142 : Property := WellDefined.toProperty WellDefined.k3Space

end PiBase.Formal
