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
public include std/math.e

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
video_modes[   0 + 1 ] = { 1,   0, 25,  40,  320, 400,  32, 8 }
video_modes[   1 + 1 ] = { 1,   1, 25,  40,  320, 400,  32, 8 }
video_modes[   2 + 1 ] = { 1,   2, 25,  80,  640, 400,  32, 8 }
video_modes[   3 + 1 ] = { 1,   3, 25,  80,  640, 400,  32, 8 }
-- video_modes[   0 + 1 ] = { 1,   0, 25,  40,    0,   0,  32, 8 }
-- video_modes[   1 + 1 ] = { 1,   1, 25,  40,    0,   0,  32, 8 }
-- video_modes[   2 + 1 ] = { 1,   2, 25,  80,    0,   0,  32, 8 }
-- video_modes[   3 + 1 ] = { 1,   3, 25,  80,    0,   0,  32, 8 }
video_modes[   4 + 1 ] = { 1,   4, 25,  40,  320, 200,   4, 1 }
video_modes[   5 + 1 ] = { 1,   5, 25,  40,  320, 200,   4, 1 }
video_modes[   6 + 1 ] = { 1,   6, 25,  80,  640, 200,   2, 1 }
-- video_modes[   7 + 1 ] = { 1,   7, 25,  80,    0,   0,  32, 8 }
video_modes[  13 + 1 ] = { 1,  13, 25,  40,  320, 200,  16, 8 }
video_modes[  14 + 1 ] = { 1,  14, 25,  80,  640, 200,  16, 4 }
video_modes[  15 + 1 ] = { 1,  15, 25,  80,  640, 350,   4, 2 }
video_modes[  16 + 1 ] = { 1,  16, 25,  80,  640, 350,  16, 2 }
video_modes[  17 + 1 ] = { 1,  17, 30,  80,  640, 480,   2, 1 }
video_modes[  18 + 1 ] = { 1,  18, 30,  80,  640, 480,  16, 1 }
video_modes[  19 + 1 ] = { 1,  19, 25,  40,  320, 200, 256, 1 }
video_modes[ 256 + 1 ] = { 1, 256, 25,  80,  640, 400, 256, 1 }
video_modes[ 257 + 1 ] = { 1, 257, 30,  80,  640, 480, 256, 1 }
video_modes[ 258 + 1 ] = { 1, 258, 40, 100,  800, 600,  16, 1 }
video_modes[ 259 + 1 ] = { 1, 259, 40, 100,  800, 600, 256, 1 }
video_modes[ 260 + 1 ] = { 1, 260, 50, 128, 1024, 768,  16, 1 }
video_modes[ 261 + 1 ] = { 1, 261, 50, 128, 1024, 768, 256, 1 }

public enum V_320x400x5 = 1, V_640x400x5 = 2, V_640x480x1 = 17,
	V_VGAx1 = 17, V_VGAx4 = 18, V_640x480x4 = 18, V_VGAx8 = 257,
	V_640x480x8 = 257, V_800x600x4 = 259, V_1024x768x8 = 261


export integer video_mode
video_mode = 3

public atom screen_size_x, screen_size_y   -- current screen size
public integer lines, columns
columns = 80
public integer cursor_line, cursor_column
cursor_line = 1 cursor_column = 1
public sequence char_buff
char_buff = {}
public integer last_text_color
last_text_color = WHITE
public integer last_bk_color
last_bk_color = BLACK

public function video_config()
    return video_modes[video_mode+1]
end function

ifdef WINDOWS then
	public include dos_rescue.ew as dos_rescue
elsedef
	public include dos_rescue.eu as dos_rescue
end ifdef

public procedure clear_screen()
-- override Euphoria built-in 
    if not window_exists then
        eu:clear_screen()
    else
        cursor_column = 1
        cursor_line = 1
        clear_region(0, 0, screen_size_x, screen_size_y)
    end if
end procedure

public procedure set_color(integer color)
-- all foreground color changes come through here
    last_text_color = color
end procedure

public procedure set_bk_color(integer color)
-- all background color changes come through here
    last_bk_color = color
end procedure

public procedure text_color(integer color)
-- was calling routine in graphics.e to set text color
-- text or graphics modes - not really needed
    if not window_exists then
        graphics:text_color(color)
    else
        last_text_color = color
    end if
end procedure

public procedure bk_color(integer color)
-- was calling routine in graphics.e to set background color
-- text or graphics modes - not really needed
    if not window_exists then
        graphics:bk_color(color)
    else
        last_bk_color = color
        dos_rescue:clear_screen()
    end if
end procedure

public function get_key()
-- override Euphoria built-in
-- get next character sent to graphics window
    integer c
    if not window_exists then
        return eu:get_key()
    else
        task_yield()
        if length(char_buff) = 0 then
            return -1
        else
            c = char_buff[1]
            char_buff = char_buff[2..$]
            return c
        end if
    end if
end function

public function wait_key()
    integer c
    c = -1
    while c = -1 do
        c = get_key()
    end while
    return c
end function

public procedure pass_key(integer key)
-- emulate key-press
    char_buff &= key
end procedure

public procedure position(integer line, integer column)
-- override Euphoria built-in 
    if not window_exists then
        eu:position(line,column)
    else
        cursor_line = line
        cursor_column = column
    end if
end procedure

public function get_position()
    return cursor_line & cursor_column
end function

public procedure puts(integer fn, object str)
-- -- override Euphoria built-in 
    sequence pos
    integer i,j
    if not window_exists or fn != STDOUT then
        eu:puts(fn,str)
    else
        if atom(str) then
            str = {str}
        end if
        i = 1
        if str[1] = '\n' then
            i += 1
            cursor_column = 1
            cursor_line += 1
        end if
        while i<=length(str) do
            j = find_from('\n',str,i)
            if j = 0 then
                j = length(str)+1
            end if
            pos = (cursor_column-1)*8 & (cursor_line)*16
            putsxy(pos,str[i..j-1],last_text_color,last_bk_color)
            cursor_column += j-i
            if j>length(str) then
                exit
            end if
            cursor_column = 1
            cursor_line += 1
            i = j+1
        end while
    end if
end procedure

public procedure printf(integer fn, sequence format, object x)
-- override Euphoria built-in 
    sequence s
    if not window_exists or fn != STDOUT then
        eu:printf(fn,format,x)
    else
        s = sprintf(format, x)
        puts(fn,s)
    end if
end procedure

public procedure print(integer fn, object x)
-- override Euphoria built-in 
    sequence s
    if not window_exists or fn != STDOUT then
        eu:print(fn,x)
    else
        s = sprint(x)
        puts(fn,s)
    end if
end procedure


------------------------------------------------------------------------------

sequence getc_buffer
getc_buffer = {}

public function gets(integer fn)
-- override Euphoria built-in 
    sequence p
    integer k
    sequence buf
    integer len,size
    
    if not window_exists or fn != STDIN then
        return eu:gets(fn)
    elsif length(getc_buffer) then
        buf = getc_buffer
        getc_buffer = {}
        return buf
    else
        buf = {}
        len = 0
        size = 0
        
        p = dos_rescue:get_position()
        while 1 do
            dos_rescue:puts(1,'_')
            dos_rescue:position(p[1],p[2])
            k = wait_key()
            if k = '\r' then
                dos_rescue:puts(1,' ')
                dos_rescue:position(p[1],p[2])
                exit
            elsif (k = 8 or k = 331) and len>0 then
                dos_rescue:position(p[1],p[2])
                dos_rescue:puts(1,' ')
                p[2] -= 1
                dos_rescue:position(p[1],p[2])
                dos_rescue:puts(1,'_')
                dos_rescue:position(p[1],p[2])
                len -= 1
            elsif k >= ' ' and k < 256 and p[2]<columns then
                dos_rescue:puts(1,k)
                p[2] += 1
                if len = size then
                    buf &= k
                    len += 1
                    size += 1
                else
                    len += 1
                    buf[len] = k
                end if
            end if
        end while
        
        if len<size then
            buf = buf[1..len]
        end if
        
        return buf & '\r'
    end if
end function

public function getc(integer fn)
-- override Euphoria built-in 
    integer c
    if not window_exists or fn != STDIN then
        return eu:getc(fn)
    elsif length(getc_buffer) = 0 then
        getc_buffer = gets(fn)
    end if
    
    c = getc_buffer[1]
    getc_buffer = getc_buffer[2..$]
    return c
end function
