module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P39.Lemmas

@[expose] public section

namespace PiBase.Formal

def P39 : Property := WellDefined.toProperty WellDefined.preirreducibleSpace

end PiBase.Formal
