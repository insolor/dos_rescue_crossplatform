without warning

-- Windows GDI equivalent routines for EUPHORIA 4 
-- for essential DOS graphics, keyboard etc.

include std/graphics.e as graphics
include std/machine.e as machine
include std/dll.e as dll
public include std/os.e
include std/text.e
include std/error.e
public include std/graphcst.e
include std/console.e
include std/math.e

export constant DOS32 = 1
export constant TRUE = 1, FALSE = 0
export constant STDIN = 0, STDOUT = 1

-- COLOR values -- for characters and pixels
-- public constant 
         -- BLACK = 0,
         -- BLUE  = 1,
         -- GREEN = 2,
         -- CYAN =  3,
         -- RED   = 4,
         -- MAGENTA = 5,
         -- BROWN = 6,
         -- WHITE = 7,
         -- GRAY  = 8,
         -- BRIGHT_BLUE = 9,
         -- BRIGHT_GREEN = 10,
         -- BRIGHT_CYAN = 11,
         -- BRIGHT_RED = 12,
         -- BRIGHT_MAGENTA = 13,
         -- YELLOW = 14,
         -- BRIGHT_WHITE = 15

export type boolean(integer x)
    return x = TRUE or x = FALSE
end type


public
function LOWORD(atom a)
    return and_bits(a, #FFFF)
end function

public
function HIWORD(atom a)
    return and_bits(a/#10000, #FFFF)
end function

export sequence video_modes
video_modes = repeat(0,262)
video_modes[   0 + 1 ] = { 1,   0, 25,  40, 320, 400,  32, 1 }
video_modes[   1 + 1 ] = { 1,   1, 25,  40, 320, 400,  32, 1 }
video_modes[   2 + 1 ] = { 1,   2, 25,  80, 640, 400,  32, 1 }
video_modes[   3 + 1 ] = { 1,   3, 25,  80, 640, 400,  32, 1 }
video_modes[   7 + 1 ] = { 1,   7, 25,  80, 640, 400,  32, 1 }
video_modes[  17 + 1 ] = { 1,  17, 30,  80, 640, 480,   2, 1 }
video_modes[  18 + 1 ] = { 1,  18, 30,  80, 640, 480,  16, 1 }

video_modes[  19 + 1 ] = { 1,  18, 30,  80, 640, 480, 256, 1 }
video_modes[ 257 + 1 ] = { 1, 257, 30,  80, 640, 480, 256, 1 }
video_modes[ 259 + 1 ] = { 1, 258, 40, 100, 800, 600,  16, 1 }
video_modes[ 261 + 1 ] = { 1, 261, 50, 128,1024, 768, 256, 1 }

public enum V_320x400x5 = 1, V_640x400x5 = 2, V_640x480x1 = 17,
	V_VGAx1 = 17, V_VGAx4 = 18, V_640x480x4 = 18, V_VGAx8 = 257,
	V_640x480x8 = 257, V_800x600x4 = 259, V_1024x768x8 = 261


export integer video_mode
video_mode = 3

-- public constant VC_COLOR = 1,
		-- VC_MODE  = 2,
		-- VC_LINES = 3,
		-- VC_COLUMNS = 4,
		-- VC_XPIXELS = 5,
		-- VC_YPIXELS = 6,
		-- VC_NCOLORS = 7,
		-- VC_PAGES = 8

public function video_config()
    -- if video_mode = -1 then
    if video_mode = -1 or platform() = DOS32 then
        return graphics:video_config()
    else
        return video_modes[video_mode+1]
    end if
end function

ifdef WINDOWS then
	public include dos_rescue.ew
elsedef
	public include dos_rescue.eu
end ifdef
