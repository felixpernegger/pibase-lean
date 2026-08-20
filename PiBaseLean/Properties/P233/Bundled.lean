module

public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P233.Lemmas

@[expose] public section

namespace PiBase.Formal

def P233 : Property := WellDefined.toProperty WellDefined.hasOpenPathComponents

end PiBase.Formal
