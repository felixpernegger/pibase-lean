module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P102.Lemmas

@[expose] public section

namespace PiBase.Formal

def P102 : Property := WellDefined.toProperty WellDefined.semimetrizableSpace

end PiBase.Formal
