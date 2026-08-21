module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P228.Lemmas

@[expose] public section

namespace PiBase.Formal

def P228 : Property := WellDefined.toProperty WellDefined.weaklyFirstCountableSpace

end PiBase.Formal
