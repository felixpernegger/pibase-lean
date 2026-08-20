module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P22.Lemmas

@[expose] public section

namespace PiBase.Formal

def P22 : Property := WellDefined.toProperty WellDefined.pseudocompactSpace

end PiBase.Formal
