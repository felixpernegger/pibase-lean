module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P129.Lemmas

@[expose] public section

namespace PiBase.Formal

def P129 : Property := WellDefined.toProperty WellDefined.indiscreteTopology

end PiBase.Formal
