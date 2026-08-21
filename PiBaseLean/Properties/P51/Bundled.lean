module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P51.Lemmas

@[expose] public section

namespace PiBase.Formal

def P51 : Property := WellDefined.toProperty scatteredSpace

end PiBase.Formal
