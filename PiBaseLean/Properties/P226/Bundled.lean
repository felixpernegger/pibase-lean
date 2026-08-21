module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P226.Lemmas

@[expose] public section

namespace PiBase.Formal

def P226 : Property := WellDefined.toProperty WellDefined.artinianSpace

end PiBase.Formal
