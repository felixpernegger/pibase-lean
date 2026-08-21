module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P125.Lemmas

@[expose] public section

namespace PiBase.Formal

def P125 : Property := WellDefined.toProperty WellDefined.nontrivial

end PiBase.Formal
