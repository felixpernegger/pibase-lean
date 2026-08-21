module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P121.Lemmas

@[expose] public section

namespace PiBase.Formal

def P121 : Property := WellDefined.toProperty WellDefined.pseudoMetrizableSpace

end PiBase.Formal
