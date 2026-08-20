module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P186.Lemmas

@[expose] public section

namespace PiBase.Formal

def P186 : Property := WellDefined.toProperty WellDefined.embedsInTopologicalWGroupSpace

end PiBase.Formal
