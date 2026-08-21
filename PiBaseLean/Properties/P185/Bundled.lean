module

public import PiBaseLean.Bundled.Defs
public import PiBaseLean.Properties.P185.Lemmas

@[expose] public section

namespace PiBase.Formal

def P185 : Property := WellDefined.toProperty WellDefined.partitionTopology

end PiBase.Formal
