module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P55.Lemmas

@[expose] public section

namespace PiBase.Formal

def P55 : Property := WellDefined.toProperty WellDefined.isCompletelyMetrizableSpace

end PiBase.Formal
