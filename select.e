		-------------------------------------
		-- search for a good graphics mode --
		-------------------------------------
include dos_rescue.e as dos_rescue

constant nice_color_modes = {261,18,260,259,258,257,256,19,16,14,13,4},
	 nice_mono_modes = {17, 11, 15, 6, 5}

global function select_mode(integer choice)
-- Try to select the choice mode, but if it fails try other modes.
-- This is not guaranteed to work - you may have to set the mode
-- yourself by editing the code.
	sequence vc, modes
	integer fail

	if not find(choice,nice_mono_modes) then
		modes = choice & nice_color_modes
	else
		modes = choice & nice_mono_modes
	end if
	for i = 1 to length(modes) do
		fail = dos_rescue:graphics_mode(modes[i])
		-- fail = graphics_mode(modes[i])
		vc = dos_rescue:video_config()
		-- vc = video_config()
		if not fail and vc[VC_XPIXELS] > 40 and vc[VC_YPIXELS] > 40 then
			return 1
		end if
	end for
	return 0
end function

