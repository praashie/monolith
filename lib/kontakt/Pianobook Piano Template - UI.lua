dofile(scriptPath .. filesystem.preferred("/lib/kontakt/ksp_utils.lua"))

local declares = string.format([[
    declare const $NUM_MICS := %s
    declare const $NUM_GROUPS_PER_MIC := %s

%s
%s
%s
]], 
num_mics,
num_groups_per_mic,
get_declare(note_groups, "note_groups"), 
get_declare(release_trigger_groups, "release_trigger_groups"), 
get_declare(pedal_groups, "pedal_groups"))

local skin = "Template_Skin"
if ui_skin then
    skin = ui_skin
end

ui_script = [[{ 

  PIANOBOOK PIANO TEMPLATE - UI SCRIPT 
  
  There are two scripts in this template. The first script is the UI Portion. 
  The second script controls the triggering of piano groups. The two scripts 
  can be used independently of eachother. There are also two versions of the UI script:
  a simple version and a multiple mic version. This is the simple version.
  
  UI scripts by Dave Hilowitz & Angus-Roberts Carey (ARC Samples)

}

on init

    { These variables are used by the Notes, RT, and Pedal knobs. 
      Remember to change the size of the  arrays (the number 
      in brackets after the array name) if you add multiple groups to any of these.}
]]..declares..[[

    { This controls how responsive the knobs are. Make sure to keep this negative if you want this to be controllable via vertical dragging. }
    declare $controlSensitivity := -500

    { DON'T EDIT BELOW THIS POINT UNLESS YOU KNOW WHAT YOU'RE DOING }

    message("")

    { Group Busses }
    declare $bus := 0
    declare $group := 1
    declare $i
    while ($bus < $NUM_MICS)
        $i := 0
        while ($i < $NUM_GROUPS_PER_MIC)
            set_engine_par($ENGINE_PAR_OUTPUT_CHANNEL, $NI_BUS_OFFSET + $bus, $group, -1, -1)
            inc($group)
            inc($i)
        end while
        inc($bus)
    end while
    
    { UI Stuff }
    { Tell Kontakt we want a visible Performance View }
    make_perfview

    { Set the UI height and width for a our Performance View }
    set_ui_height_px(280) 
    set_ui_width_px(633)

    set_control_par_str($INST_ICON_ID,$CONTROL_PAR_PICTURE,"BLANK_ICON")
    set_control_par_str($INST_WALLPAPER_ID,$CONTROL_PAR_PICTURE,"]]..skin..[[")

    { This variable will be used for setting volumes in the knob handlers below. }
    declare $count

    { Declare top row of controls. These control volumes for the three busses. }
    declare ui_slider $NotesSlider(1, 630000)
    $NotesSlider := 630000
    set_knob_defval($NotesSlider, 630000)
    make_persistent($NotesSlider)
    declare $NotesSliderId
    $NotesSliderId := get_ui_id($NotesSlider)
    set_control_par_str($NotesSliderId, $CONTROL_PAR_PICTURE, "ARC_Knob")
    set_control_par($NotesSliderId,$CONTROL_PAR_MOUSE_BEHAVIOUR, $controlSensitivity)

    declare ui_slider $RTSlider(1, 630000)
    $RTSlider := 630000
    set_knob_defval($RTSlider, 630000)
    make_persistent($RTSlider)
    declare $RTSliderId
    $RTSliderId := get_ui_id($RTSlider)
    set_control_par_str($RTSliderId, $CONTROL_PAR_PICTURE, "ARC_Knob")
    set_control_par($RTSliderId,$CONTROL_PAR_MOUSE_BEHAVIOUR, $controlSensitivity)

    declare ui_slider $PedalsSlider(1, 630000)
    $PedalsSlider := 630000
    set_knob_defval($PedalsSlider, 630000)
    make_persistent($PedalsSlider)
    declare $PedalsSliderId
    $PedalsSliderId := get_ui_id($PedalsSlider)
    set_control_par_str($PedalsSliderId, $CONTROL_PAR_PICTURE, "ARC_Knob")
    set_control_par($PedalsSliderId,$CONTROL_PAR_MOUSE_BEHAVIOUR, $controlSensitivity)

    { Positions the top row of controls }
    move_control_px($NotesSlider,  295, 95)
    move_control_px($RTSlider,     395, 95)
    move_control_px($PedalsSlider, 495, 95)

    { Declare knobs for the bottom row of controls }
    declare ui_slider $Vol(0, 100)
    $Vol := 100
    set_knob_defval($Vol, 100)
    make_persistent($Vol)
    declare $VolId
    $VolId := get_ui_id($Vol)
    set_control_par_str($VolId, $CONTROL_PAR_PICTURE, "ARC_Knob")
    set_control_par($VolId,$CONTROL_PAR_MOUSE_BEHAVIOUR,$controlSensitivity)

    declare ui_slider $FxOne(0, 1000000)
    $FxOne := 0
    set_knob_defval($FxOne, 0)
    make_persistent($FxOne)
    declare $FxOneId
    $FxOneId := get_ui_id($FxOne)
    set_control_par_str($FxOneId, $CONTROL_PAR_PICTURE, "ARC_Knob")
    set_control_par($FxOneId,$CONTROL_PAR_MOUSE_BEHAVIOUR,$controlSensitivity)

    declare ui_slider $FxTwo(0, 500000)
    $FxTwo := 0
    set_knob_defval($FxTwo, 0)
    make_persistent($FxTwo)
    declare $FxTwoId
    $FxTwoId := get_ui_id($FxTwo)
    set_control_par_str($FxTwoId, $CONTROL_PAR_PICTURE, "ARC_Knob")
    set_control_par($FxTwoId,$CONTROL_PAR_MOUSE_BEHAVIOUR,$controlSensitivity)

    { Positions the bottom row of controls }
    move_control_px($Vol,   295, 195)
    move_control_px($FxOne, 395, 195)
    move_control_px($FxTwo, 495, 195)

    declare $VolLevel

end on

on ui_control($NotesSlider)
    { Sets the volume of the `Notes` groups. }
    $count := 0
    while($count < num_elements(%note_groups))
        set_engine_par($ENGINE_PAR_VOLUME, $NotesSlider, %note_groups[$count], -1, -1)
        inc($count)
    end while  
end on

on ui_control($RTSlider)
    { Sets the volume of the `Release Trigger` groups. }
    $count := 0
    while($count < num_elements(%release_trigger_groups))
        set_engine_par($ENGINE_PAR_VOLUME, $RTSlider, %release_trigger_groups[$count], -1, -1)
        inc($count)
    end while
end on

on ui_control($PedalsSlider)
    { Sets the volume of the `Pedal` groups. }
    $count := 0
    while($count < num_elements(%pedal_groups))
        set_engine_par($ENGINE_PAR_VOLUME, $PedalsSlider, %pedal_groups[$count], -1, -1)
        inc($count)
    end while 
end on

on ui_control($Vol)
    $VolLevel := 6300 * $Vol
    set_engine_par($ENGINE_PAR_VOLUME, $VolLevel, -1, -1, $NI_BUS_OFFSET)
end on

on ui_control($FxOne)
    set_engine_par($ENGINE_PAR_SENDLEVEL_0, $FxOne,-1,7 ,0)
end on 

on ui_control($FxTwo)
    set_engine_par($ENGINE_PAR_SENDLEVEL_1, $FxTwo,-1,7 ,0)
end on
]]
