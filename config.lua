local AutumnPiano={ 
    instrument="Autumn Piano (Multi)",
    prefix={"DRY", "SLATE", "TAPE"},
    filepath={"samples/AUTUMN PIANO DRY.wav","samples/AUTUMN PIANO SLATE.wav","samples/AUTUMN PIANO TAPE.wav"},
    flavour="DEFAULT",
    bpm=120
}

local AutumnPianoDry={ 
    instrument="Autumn Piano",
    prefix="DRY",
    filepath="samples/AUTUMN PIANO DRY.wav",
    flavour="DEFAULT",
    bpm=120
}

local ClaustrophobicMIX456={ 
    instrument="Claustrophobic Piano (MIX456)",
    prefix="MIX456",
    filepath="samples/Claustrophobic Piano Mix 756_NR.wav",
    flavour="SAME_PEDALS"
}

local ClaustrophobicKU100={ 
    instrument="Claustrophobic Piano (KU100)",
    prefix="KU100",
    filepath="samples/Claustrophobic Piano KU 100_NR.wav",
     flavour="SAME_PEDALS"
}

local ClaustrophobicM149={ 
    instrument="Claustrophobic Piano (M149)",
    prefix="M149",
    filepath="samples/Claustrophobic Piano M149_NR.wav",
    flavour="SAME_PEDALS"
}

local ClaustrophobicPiano={ 
    instrument="Claustrophobic Piano",
    prefix={"KU100", "M149", "MIX456"},
    filepath={"samples/Claustrophobic Piano KU 100_NR.wav","samples/Claustrophobic Piano M149_NR.wav","samples/Claustrophobic Piano Mix 756_NR.wav"},
    flavour="SAME_PEDALS"
}

local FamilyGrand={ 
    instrument="Family Grand",
    prefix={"149s", "KU100"},
    filepath={"samples/Family Piano 149s v2.0_NR.wav","samples/Family Piano KU100 v2.0_NR.wav"},
    flavour="SAME_PEDALS"
}

local FamilyGrandStereo={ 
    instrument="Family Grand (Stereo)",
    prefix="149s",
    filepath="samples/Family Piano 149s v2.0_NR.wav",
    flavour="SAME_PEDALS"
}

local FamilyGrandBinaural={ 
    instrument="Family Grand (Binaural)",
    prefix="KU100",
    filepath="samples/Family Piano KU100 v2.0_NR.wav",
    flavour="SAME_PEDALS"
}

local FlannelPiano={ 
    instrument="Flannel Piano",
    prefix={"4006", "R88", "U67"},
    filepath={"samples/4006 Flannel EditNR.wav","samples/R88 Flannel EditNR.wav","samples/U67 Flannel EditNR.wav"},
    flavour="GIMP"
}

local FlannelPiano4006={ 
    instrument="Flannel Piano (4006)",
    prefix="4006",
    filepath="samples/4006 Flannel EditNR.wav",
    flavour="GIMP"
}

local FlannelPianoR88={ 
    instrument="Flannel Piano (R88)",
    prefix="R88",
    filepath="samples/R88 Flannel EditNR.wav",
    flavour="GIMP"
}

local FlannelPianoU67={ 
    instrument="Flannel Piano (U67)",
    prefix="U67",
    filepath="samples/U67 Flannel EditNR.wav",
    flavour="GIMP"
}

local GIMP={ 
    instrument="GIMP",
    prefix={"4006", "R88", "U67"},
    filepath={"samples/4006 NR.wav","samples/R88 NR.wav","samples/U67 NR.wav"},
    flavour="GIMP"
}

local GIMP4006={ 
    instrument="GIMP (4006)",
    prefix="4006",
    filepath="samples/4006 NR.wav",
    flavour="GIMP"
}

local GIMPR88={ 
    instrument="GIMP (R88)",
    prefix="R88",
    filepath="samples/R88 NR.wav",
    flavour="GIMP"
}

local GIMPU67={ 
    instrument="GIMP (U67)",
    prefix="U67",
    filepath="samples/U67 NR.wav",
    flavour="GIMP"
}

local Default={
    instrument="Monolith Template",
    prefix="MIC1",
    filepath="samples/DOES_NOT_EXIST.wav",
    --flavour="DEFAULT",
    --using_split=false,
    --bmp=115.2
}

local DefaultMulti={
    instrument="Monolith Template (Multi Mic)",
    prefix={"MIC1","MIC2","MIC3"},
    filepath={"samples/MIC1.wav","samples/MIC2.wav","samples/MIC3.wav"},
    --flavour="DEFAULT",
    --using_split=false,
    --bmp=115.2
}

config=Default