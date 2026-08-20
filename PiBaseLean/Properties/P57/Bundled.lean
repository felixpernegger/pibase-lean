module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P57.Lemmas

@[expose] public section

namespace PiBase.Formal

def P57 : Property := WellDefined.toProperty WellDefined.countable

end PiBase.Formal
