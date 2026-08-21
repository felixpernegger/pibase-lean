module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P194.Lemmas

@[expose] public section

namespace PiBase.Formal

def P194 : Property := WellDefined.toProperty WellDefined.submetacompactSpace

end PiBase.Formal
