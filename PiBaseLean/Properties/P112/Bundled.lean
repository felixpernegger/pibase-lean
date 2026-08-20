module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P112.Lemmas

@[expose] public section

namespace PiBase.Formal

def P112 : Property := WellDefined.toProperty WellDefined.submetrizableSpace

end PiBase.Formal
