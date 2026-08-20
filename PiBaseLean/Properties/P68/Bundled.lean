module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P68.Lemmas

@[expose] public section

namespace PiBase.Formal

def P68 : Property := WellDefined.toProperty WellDefined.rothbergerSpace

end PiBase.Formal
