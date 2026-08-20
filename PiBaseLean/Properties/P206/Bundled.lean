module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P206.Lemmas

@[expose] public section

namespace PiBase.Formal

def P206 : Property := WellDefined.toProperty WellDefined.stronglyChoquetSpace

end PiBase.Formal
