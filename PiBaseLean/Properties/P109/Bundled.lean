module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P109.Lemmas

@[expose] public section

namespace PiBase.Formal

def P109 : Property := WellDefined.toProperty WellDefined.monotonicallyNormalSpace

end PiBase.Formal
