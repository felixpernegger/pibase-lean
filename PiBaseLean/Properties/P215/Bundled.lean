module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P215.Lemmas

@[expose] public section

namespace PiBase.Formal

def P215 : Property := WellDefined.toProperty WellDefined.hereditarilyRealcompactSpace

end PiBase.Formal
