module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P216.Lemmas

@[expose] public section

namespace PiBase.Formal

def P216 : Property := WellDefined.toProperty WellDefined.hereditarilyParacompact

end PiBase.Formal
