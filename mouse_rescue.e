include dos_rescue.ew
public include std/math.e

public constant
    MOVE        = 1,
    LEFT_DOWN   = 2,
    LEFT_UP     = 4,
    RIGHT_DOWN  = 8,
    RIGHT_UP    = 16,
    MIDDLE_DOWN = 32,
    MIDDLE_UP   = 64,
    $

-- constant M_GET_MOUSE = 14,
	 -- M_MOUSE_EVENTS = 15,
	 -- M_MOUSE_POINTER = 24

sequence mouse_buff
mouse_buff = {}

public function get_mouse()
-- report mouse events,
-- returns -1 if no mouse event,
-- otherwise returns {event#, x-coord, y-coord}
    -- return machine_func(M_GET_MOUSE, 0)
    sequence event
    task_yield()
    if length(mouse_buff) = 0 then
        return 0
    else
        event = mouse_buff[1]
        mouse_buff = mouse_buff[2..$]
        return event
    end if
end function

ifdef WINDOWS then
	public include mouse_rescue.ew
elsedef
	public include mouse_rescue.eu
end ifdef
