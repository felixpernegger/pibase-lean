module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P146.Lemmas

@[expose] public section

namespace PiBase.Formal

def P146 : Property := WellDefined.toProperty WellDefined.ultraparacompactSpace

end PiBase.Formal
