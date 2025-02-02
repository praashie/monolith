dofile(scriptPath .. filesystem.preferred("/lib/kontakt/ksp_utils.lua"))

local declares = string.format([[
    declare const $NUM_MICS := %s

%s
%s
%s
%s
%s
]],
num_mics, 
get_declare(note_without_pedal_groups, "note_without_pedal_groups"), 
get_declare(note_with_pedal_groups, "note_with_pedal_groups"),
get_declare(release_trigger_groups, "release_trigger_groups"),
get_declare(pedal_down_groups, "pedal_down_groups"),
get_declare(pedal_up_groups, "pedal_up_groups"))

trigger_script = [[{ 

  PIANOBOOK PIANO TEMPLATE - VOICE TRIGGERING SCRIPT 
  
  There are two scripts in this template. The first script is the UI Portion. 
  The second script controls the triggering of piano groups. The two scripts 
  can be used independently of eachother.
  
  Note triggering scripts by Dave Hilowitz
  UI scripts by Angus-Roberts Carey (ARC Samples) 

}

on init

    { SETTINGS:
      Set the values below to the correct groups for your instrument.
      If you don't have samples for one of these group types, leave the
      array empty. An empty array looks like this: ().
      
      You must at least have a $note_without_pedal_group.
      By default, this template is set up with four round robins per sound type–
      that's why there's a number 4 in the array declarations below, eg. 4 * $NUM_MICS.
      If you change the number of round robins, you'll also want to change this number.
      You do not need to use the round robin functionality of this template. 
      It is perfectly fine to have only one group in each of these arrays.
      It is assumed that if there is more than one group in any of 
      these, we will do round robins. Remember to change the size of
      the arrays (the first number in brackets after the array name) if you
      add multiple groups to any of these. }

]]..declares..[[

    { Release time that gets used when finger is let up on keys }
    declare $key_up_release_time_ms        := 400
    { If you set this to 0, the round robins will be sequential, otherwise 
    they will be random (but with code to prevent the same sample triggering twice 
    in a row).} 
    declare $randomize_round_robins := 0

    { DON'T EDIT BELOW THIS POINT UNLESS YOU KNOW WHAT YOU'RE DOING }

    SET_CONDITION(NO_SYS_SCRIPT_PEDAL)
    SET_CONDITION(NO_SYS_SCRIPT_RLS_TRIG)
    message("")
    declare $i
    declare $tmp_note_id
    declare $tmp_event_note
    declare polyphonic $ignored_event_id
    declare const $ARRAY_SIZE := 500
    declare %tmp_event_ids[$ARRAY_SIZE]
    
    declare $pedal_down := 0
    declare $func_play_note_midi_note
    declare $func_play_note_velocity
    declare $func_play_note_type
    declare $func_stop_note_midi_note

    { Round robin tracking stuff }
    declare $tmp_rr := 0
    declare $tmp_num_round_robins
    declare $tmp_last_rr
    declare %last_rr[5] := (0,0,0,0,0)
    declare %notes_playing[128]
    
end on

function func_play_note
    { message("func_play_generic_note") }
    $tmp_last_rr := %last_rr[$func_play_note_type-1]
    select($func_play_note_type)
        case 1
            $tmp_num_round_robins := num_elements(%note_without_pedal_groups) / $NUM_MICS
        case 2
            $tmp_num_round_robins := num_elements(%note_with_pedal_groups) / $NUM_MICS
        case 3
            $tmp_num_round_robins := num_elements(%release_trigger_groups) / $NUM_MICS
        case 4
            $tmp_num_round_robins := num_elements(%pedal_down_groups) / $NUM_MICS
            $func_play_note_midi_note := 64
            $func_play_note_velocity := 64
        case 5
            $tmp_num_round_robins := num_elements(%pedal_up_groups) / $NUM_MICS
            $func_play_note_midi_note := 64
            $func_play_note_velocity := 64
    end select

    if($tmp_num_round_robins <= 0)
        exit
    else
        if($tmp_num_round_robins = 1)
            $tmp_rr := 0
        else
            if($tmp_num_round_robins = 2) 
                $tmp_rr := 1 - $tmp_last_rr
            else
                if($randomize_round_robins = 1) 
                    $tmp_rr := random(0,$tmp_num_round_robins - 1)
                    while($tmp_rr = $tmp_last_rr) 
                        $tmp_rr := random(0,$tmp_num_round_robins - 1)
                    end while
                else
                    if (($tmp_last_rr + 1) > ($tmp_num_round_robins - 1))
                        $tmp_rr := 0
                    else
                        $tmp_rr := $tmp_last_rr + 1
                    end if
                end if
            end if
        end if
    end if


    $tmp_note_id := play_note($func_play_note_midi_note, $func_play_note_velocity, 0, -1) 
    set_event_par_arr($tmp_note_id,$EVENT_PAR_ALLOW_GROUP,0,$ALL_GROUPS)

    if($func_play_note_type = 1)
        if (%notes_playing[$func_play_note_midi_note] > 0)
            fade_out(%notes_playing[$func_play_note_midi_note], 20000, 1)
        end if
        %notes_playing[$func_play_note_midi_note] := $tmp_note_id
    end if

    { message("RR: " & $tmp_rr) }
    %last_rr[$func_play_note_type-1] := $tmp_rr
    $i:= 0
    while($i<$NUM_MICS)
        select($func_play_note_type)
            case 1
                set_event_par_arr($tmp_note_id,$EVENT_PAR_ALLOW_GROUP,1, %note_without_pedal_groups[$i*$tmp_num_round_robins + $tmp_rr])
            case 2
                set_event_par_arr($tmp_note_id,$EVENT_PAR_ALLOW_GROUP,1, %note_with_pedal_groups[$i*$tmp_num_round_robins + $tmp_rr])
            case 3
                set_event_par_arr($tmp_note_id,$EVENT_PAR_ALLOW_GROUP,1, %release_trigger_groups[$i*$tmp_num_round_robins + $tmp_rr])
            case 4
                set_event_par_arr($tmp_note_id,$EVENT_PAR_ALLOW_GROUP,1, %pedal_down_groups[$i*$tmp_num_round_robins + $tmp_rr])
            case 5
                set_event_par_arr($tmp_note_id,$EVENT_PAR_ALLOW_GROUP,1, %pedal_up_groups[$i*$tmp_num_round_robins + $tmp_rr])
        end select
        inc($i)
    end while
end function

function func_stop_all_non_held_notes
    { message("func_stop_all_non_held_notes called") }
    get_event_ids(%tmp_event_ids)
    $i := 0
    { $note_count := 0 }
    while($i < $ARRAY_SIZE and %tmp_event_ids[$i] # 0)
        { message("event found: " & %tmp_event_ids[$i]) }
        $tmp_event_note := get_event_par(%tmp_event_ids[$i], $EVENT_PAR_NOTE) 
        { message("event " & %tmp_event_ids[$i] & "; MIDI note " & $tmp_event_note & "; keydown=" & %KEY_DOWN[$tmp_event_note]) }
        if (%KEY_DOWN[$tmp_event_note] = 0)
            { message("Stopping MIDI note: " & $tmp_event_note) }
            { stop it! }
            fade_out(%tmp_event_ids[$i], $key_up_release_time_ms * 1000, 1)
            { note_off($i) }
            { %notes_playing[$tmp_event_note] := 0 }
        end if
        inc($i)
    end while
    { message("Active Events: " & $note_count) }
end function

{ cycle through all events that are currently taking place 
  and stop any note that has the same MIDI note number }
        
function func_stop_midi_note_if_playing
    { message("func_stop_midi_note_if_playing called") }
    get_event_ids(%tmp_event_ids)
    $i := 0
    while($i < $ARRAY_SIZE and %tmp_event_ids[$i] # 0)
        if (event_status(%tmp_event_ids[$i]) = $EVENT_STATUS_NOTE_QUEUE and %tmp_event_ids[$i] # $ignored_event_id)
            { message("event found: " & %tmp_event_ids[$i]) }
            $tmp_event_note := get_event_par(%tmp_event_ids[$i], $EVENT_PAR_NOTE) 
            { message("event " & %tmp_event_ids[$i] & "; MIDI note " & $tmp_event_note & "; keydown=" & %KEY_DOWN[$tmp_event_note]) }
            if ($func_stop_note_midi_note = $tmp_event_note)
                { message("Stopping MIDI note: " & $tmp_event_note) }
                { stop it! }
                fade_out(%tmp_event_ids[$i], $key_up_release_time_ms * 1000, 1)
                { note_off($i) }          
            end if
        end if
        inc($i)
    end while
    
    { %notes_playing[$func_stop_note_midi_note] := 0 }
end function

on controller
    if ($CC_NUM = 64)
        if (%CC[64] > 64)
            if($pedal_down = 0)
                $func_play_note_type := 4
                call func_play_note
                $pedal_down := 1
            end if 
        else
            if($pedal_down = 1)
                call func_stop_all_non_held_notes
                $func_play_note_type := 5
                call func_play_note
                $pedal_down := 0
            end if
        end if
    end if
end on

on note
    ignore_event($EVENT_ID)
    { message($EVENT_ID) }
    $ignored_event_id := $EVENT_ID
    
    $func_play_note_midi_note := $EVENT_NOTE
    $func_play_note_velocity := $EVENT_VELOCITY

    if (%CC[64] >= 64)
        $func_play_note_type := 2
        call func_play_note
    else
        
        $func_stop_note_midi_note := $func_play_note_midi_note
        call func_stop_midi_note_if_playing       
        $func_play_note_type := 1
        call func_play_note
    end if
end on

on release 
    ignore_event($EVENT_ID)
    { message("release event: " & $EVENT_ID) }
    if($EVENT_ID = $ignored_event_id) 
        exit
    end if
    
    if(%CC[64] < 64)
        $func_stop_note_midi_note := $EVENT_NOTE
        call func_stop_midi_note_if_playing
    end if    

    { We play the release trigger regardless of whether or not the pedal is down. }
    
    $func_play_note_midi_note := $EVENT_NOTE
    $func_play_note_velocity := $EVENT_VELOCITY
    $func_play_note_type := 3
    call func_play_note
end on
]]
