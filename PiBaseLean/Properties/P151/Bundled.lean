module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P151.Lemmas

@[expose] public section

namespace PiBase.Formal

def P151 : Property := WellDefined.toProperty WellDefined.strategicallyRothbergerSpace

end PiBase.Formal
