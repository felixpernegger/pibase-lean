module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P141.Lemmas

@[expose] public section

namespace PiBase.Formal

def P141 : Property := WellDefined.toProperty WellDefined.compactlyGeneratedSpace

end PiBase.Formal
