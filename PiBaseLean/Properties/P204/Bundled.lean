module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P204.Lemmas

@[expose] public section

namespace PiBase.Formal

def P204 : Property := WellDefined.toProperty WellDefined.hasACutPoint

end PiBase.Formal
