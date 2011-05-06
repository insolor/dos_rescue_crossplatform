/***********************************************************
Copyright 1987, 1994, 1998  The Open Group

Permission to use, copy, modify, distribute, and sell this software and its
documentation for any purpose is hereby granted without fee, provided that
the above copyright notice appear in all copies and that both that
copyright notice and this permission notice appear in supporting
documentation.

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE OPEN GROUP BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of The Open Group shall
not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization
from The Open Group.


Copyright 1987 by Digital Equipment Corporation, Maynard, Massachusetts

                        All Rights Reserved

Permission to use, copy, modify, and distribute this software and its
documentation for any purpose and without fee is hereby granted,
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in
supporting documentation, and that the name of Digital not be
used in advertising or publicity pertaining to distribution of the
software without specific, written prior permission.

DIGITAL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
DIGITAL BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
SOFTWARE.

******************************************************************/

/*
 * The "X11 Window System Protocol" standard defines in Appendix A the
 * keysym codes. These 29-bit integer values identify characters or
 * functions associated with each key (e.g., via the visible
 * engraving) of a keyboard layout. This file assigns mnemonic macro
 * names for these keysyms.
 *
 * This file is also compiled (by src/util/makekeys.c in libX11) into
 * hash tables that can be accessed with X11 library functions such as
 * XStringToKeysym() and XKeysymToString().
 *
 * Where a keysym corresponds one-to-one to an ISO 10646 / Unicode
 * character, this is noted in a comment that provides both the U+xxxx
 * Unicode position, as well as the official Unicode name of the
 * character.
 *
 * Where the correspondence is either not one-to-one or semantically
 * unclear, the Unicode position and name are enclosed in
 * parentheses. Such legacy keysyms should be considered deprecated
 * and are not recommended for use in future keyboard mappings.
 *
 * For any future extension of the keysyms with characters already
 * found in ISO 10646 / Unicode, the following algorithm shall be
 * used. The new keysym code position will simply be the character's
 * Unicode number plus = 0x01000000. The keysym values in the range
 * = 0x01000100 to = 0x0110ffff are reserved to represent Unicode
 * characters in the range U+0100 to U+10FFFF.
 * 
 * While most newer Unicode-based X11 clients do already accept
 * Unicode-mapped keysyms in the range = 0x01000100 to = 0x0110ffff, it
 * will remain necessary for clients -- in the interest of
 * compatibility with existing servers -- to also understand the
 * existing legacy keysym values in the range = 0x0100 to = 0x20ff.
 *
 * Where several mnemonic names are defined for the same keysym in this
 * file, all but the first one listed should be considered deprecated.
 *
 * Mnemonic names for keysyms are defined in this file with lines
 * that match one of these Perl regular expressions:
 *
 *    /^\	XK_([a-zA-Z_0-9]+)\s+= 0x([0-9a-f]+)\s*\/\* U+([0-9A-F]{4,6}) (.*) \*\/\s*$/
 *    /^\	XK_([a-zA-Z_0-9]+)\s+= 0x([0-9a-f]+)\s*\/\*\(U+([0-9A-F]{4,6}) (.*)\)\*\/\s*$/
 *    /^\	XK_([a-zA-Z_0-9]+)\s+= 0x([0-9a-f]+)\s*(\/\*\s*(.*)\s*\*\/)?\s*$/
 *
 * Before adding new keysyms, please do consider the following: In
 * addition to the keysym names defined in this file, the
 * XStringToKeysym() and XKeysymToString() functions will also handle
 * any keysym string of the form "U0020" to "U007E" and "U00A0" to
 * "U10FFFF" for all possible Unicode characters. In other words,
 * every possible Unicode character has already a keysym string
 * defined algorithmically, even if it is not listed here. Therefore,
 * defining an additional keysym macro is only necessary where a
 * non-hexadecimal mnemonic name is needed, or where the new keysym
 * does not represent any existing Unicode character.
 *
 * When adding new keysyms to this file, do not forget to also update the
 * following:
 *
 *   - the mappings in src/KeyBind.c in the repo
 *     git://anongit.freedesktop.org/xorg/lib/libX11
 *
 *   - the protocol specification in specs/XProtocol/X11.keysyms
 *     in the repo git://anongit.freedesktop.org/xorg/doc/xorg-docs
 *
 */

public sequence symmap = repeat( 0, 0x10000 )
procedure asciimap( object keysyms )
	if atom( keysyms ) then
		symmap[keysyms] = and_bits( 0xff, keysyms )
	end if
	
	for i = 1 to length( keysyms ) do
		symmap[keysyms[i]] = and_bits( 0xff, keysyms[i] )
	end for
end procedure


public constant

	XK_VoidSymbol                  = 0xffffff,  /* Void symbol */

/*
 * TTY function keys, cleverly chosen to map to ASCII, for convenience of
 * programming, but could have been arbitrary (at the cost of lookup
 * tables in client code).
 */

	XK_BackSpace                     = 0xff08,  /* Back space, back char */
	XK_Tab                           = 0xff09,
	XK_Linefeed                      = 0xff0a,  /* Linefeed, LF */
	XK_Clear                         = 0xff0b,
	XK_Return                        = 0xff0d,  /* Return, enter */
	XK_Pause                         = 0xff13,  /* Pause, hold */
	XK_Scroll_Lock                   = 0xff14,
	XK_Sys_Req                       = 0xff15,
	XK_Escape                        = 0xff1b,
	XK_Delete                        = 0xffff,  /* Delete, rubout */



/* International & multi-key character composition */

	XK_Multi_key                     = 0xff20,  /* Multi-key character compose */
	XK_Codeinput                     = 0xff37,
	XK_SingleCandidate               = 0xff3c,
	XK_MultipleCandidate             = 0xff3d,
	XK_PreviousCandidate             = 0xff3e,

/* Japanese keyboard support */

	XK_Kanji                         = 0xff21,  /* Kanji, Kanji convert */
	XK_Muhenkan                      = 0xff22,  /* Cancel Conversion */
	XK_Henkan_Mode                   = 0xff23,  /* Start/Stop Conversion */
	XK_Henkan                        = 0xff23,  /* Alias for Henkan_Mode */
	XK_Romaji                        = 0xff24,  /* to Romaji */
	XK_Hiragana                      = 0xff25,  /* to Hiragana */
	XK_Katakana                      = 0xff26,  /* to Katakana */
	XK_Hiragana_Katakana             = 0xff27,  /* Hiragana/Katakana toggle */
	XK_Zenkaku                       = 0xff28,  /* to Zenkaku */
	XK_Hankaku                       = 0xff29,  /* to Hankaku */
	XK_Zenkaku_Hankaku               = 0xff2a,  /* Zenkaku/Hankaku toggle */
	XK_Touroku                       = 0xff2b,  /* Add to Dictionary */
	XK_Massyo                        = 0xff2c,  /* Delete from Dictionary */
	XK_Kana_Lock                     = 0xff2d,  /* Kana Lock */
	XK_Kana_Shift                    = 0xff2e,  /* Kana Shift */
	XK_Eisu_Shift                    = 0xff2f,  /* Alphanumeric Shift */
	XK_Eisu_toggle                   = 0xff30,  /* Alphanumeric toggle */
	XK_Kanji_Bangou                  = 0xff37,  /* Codeinput */
	XK_Zen_Koho                      = 0xff3d,  /* Multiple/All Candidate(s) */
	XK_Mae_Koho                      = 0xff3e,  /* Previous Candidate */

/* = 0xff31 thru = 0xff3f are under XK_KOREAN */

/* Cursor control & motion */

	XK_Home                          = 0xff50,
	XK_Left                          = 0xff51,  /* Move left, left arrow */
	XK_Up                            = 0xff52,  /* Move up, up arrow */
	XK_Right                         = 0xff53,  /* Move right, right arrow */
	XK_Down                          = 0xff54,  /* Move down, down arrow */
	XK_Prior                         = 0xff55,  /* Prior, previous */
	XK_Page_Up                       = 0xff55,
	XK_Next                          = 0xff56,  /* Next */
	XK_Page_Down                     = 0xff56,
	XK_End                           = 0xff57,  /* EOL */
	XK_Begin                         = 0xff58,  /* BOL */


/* Misc functions */

	XK_Select                        = 0xff60,  /* Select, mark */
	XK_Print                         = 0xff61,
	XK_Execute                       = 0xff62,  /* Execute, run, do */
	XK_Insert                        = 0xff63,  /* Insert, insert here */
	XK_Undo                          = 0xff65,
	XK_Redo                          = 0xff66,  /* Redo, again */
	XK_Menu                          = 0xff67,
	XK_Find                          = 0xff68,  /* Find, search */
	XK_Cancel                        = 0xff69,  /* Cancel, stop, abort, exit */
	XK_Help                          = 0xff6a,  /* Help */
	XK_Break                         = 0xff6b,
	XK_Mode_switch                   = 0xff7e,  /* Character set switch */
	XK_script_switch                 = 0xff7e,  /* Alias for mode_switch */
	XK_Num_Lock                      = 0xff7f,

/* Keypad functions, keypad numbers cleverly chosen to map to ASCII */

	XK_KP_Space                      = 0xff80,  /* Space */
	XK_KP_Tab                        = 0xff89,
	XK_KP_Enter                      = 0xff8d,  /* Enter */
	XK_KP_F1                         = 0xff91,  /* PF1, KP_A, ... */
	XK_KP_F2                         = 0xff92,
	XK_KP_F3                         = 0xff93,
	XK_KP_F4                         = 0xff94,
	XK_KP_Home                       = 0xff95,
	XK_KP_Left                       = 0xff96,
	XK_KP_Up                         = 0xff97,
	XK_KP_Right                      = 0xff98,
	XK_KP_Down                       = 0xff99,
	XK_KP_Prior                      = 0xff9a,
	XK_KP_Page_Up                    = 0xff9a,
	XK_KP_Next                       = 0xff9b,
	XK_KP_Page_Down                  = 0xff9b,
	XK_KP_End                        = 0xff9c,
	XK_KP_Begin                      = 0xff9d,
	XK_KP_Insert                     = 0xff9e,
	XK_KP_Delete                     = 0xff9f,
	XK_KP_Equal                      = 0xffbd,  /* Equals */
	XK_KP_Multiply                   = 0xffaa,
	XK_KP_Add                        = 0xffab,
	XK_KP_Separator                  = 0xffac,  /* Separator, often comma */
	XK_KP_Subtract                   = 0xffad,
	XK_KP_Decimal                    = 0xffae,
	XK_KP_Divide                     = 0xffaf,

	XK_KP_0                          = 0xffb0,
	XK_KP_1                          = 0xffb1,
	XK_KP_2                          = 0xffb2,
	XK_KP_3                          = 0xffb3,
	XK_KP_4                          = 0xffb4,
	XK_KP_5                          = 0xffb5,
	XK_KP_6                          = 0xffb6,
	XK_KP_7                          = 0xffb7,
	XK_KP_8                          = 0xffb8,
	XK_KP_9                          = 0xffb9,



/*
 * Auxiliary functions; note the duplicate definitions for left and right
 * function keys;  Sun keyboards and a few other manufacturers have such
 * function key groups on the left and/or right sides of the keyboard.
 * We've not found a keyboard with more than 35 function keys total.
 */

	XK_F1                            = 0xffbe,
	XK_F2                            = 0xffbf,
	XK_F3                            = 0xffc0,
	XK_F4                            = 0xffc1,
	XK_F5                            = 0xffc2,
	XK_F6                            = 0xffc3,
	XK_F7                            = 0xffc4,
	XK_F8                            = 0xffc5,
	XK_F9                            = 0xffc6,
	XK_F10                           = 0xffc7,
	XK_F11                           = 0xffc8,
	XK_L1                            = 0xffc8,
	XK_F12                           = 0xffc9,
	XK_L2                            = 0xffc9,
	XK_F13                           = 0xffca,
	XK_L3                            = 0xffca,
	XK_F14                           = 0xffcb,
	XK_L4                            = 0xffcb,
	XK_F15                           = 0xffcc,
	XK_L5                            = 0xffcc,
	XK_F16                           = 0xffcd,
	XK_L6                            = 0xffcd,
	XK_F17                           = 0xffce,
	XK_L7                            = 0xffce,
	XK_F18                           = 0xffcf,
	XK_L8                            = 0xffcf,
	XK_F19                           = 0xffd0,
	XK_L9                            = 0xffd0,
	XK_F20                           = 0xffd1,
	XK_L10                           = 0xffd1,
	XK_F21                           = 0xffd2,
	XK_R1                            = 0xffd2,
	XK_F22                           = 0xffd3,
	XK_R2                            = 0xffd3,
	XK_F23                           = 0xffd4,
	XK_R3                            = 0xffd4,
	XK_F24                           = 0xffd5,
	XK_R4                            = 0xffd5,
	XK_F25                           = 0xffd6,
	XK_R5                            = 0xffd6,
	XK_F26                           = 0xffd7,
	XK_R6                            = 0xffd7,
	XK_F27                           = 0xffd8,
	XK_R7                            = 0xffd8,
	XK_F28                           = 0xffd9,
	XK_R8                            = 0xffd9,
	XK_F29                           = 0xffda,
	XK_R9                            = 0xffda,
	XK_F30                           = 0xffdb,
	XK_R10                           = 0xffdb,
	XK_F31                           = 0xffdc,
	XK_R11                           = 0xffdc,
	XK_F32                           = 0xffdd,
	XK_R12                           = 0xffdd,
	XK_F33                           = 0xffde,
	XK_R13                           = 0xffde,
	XK_F34                           = 0xffdf,
	XK_R14                           = 0xffdf,
	XK_F35                           = 0xffe0,
	XK_R15                           = 0xffe0,

/* Modifiers */

	XK_Shift_L                       = 0xffe1,  /* Left shift */
	XK_Shift_R                       = 0xffe2,  /* Right shift */
	XK_Control_L                     = 0xffe3,  /* Left control */
	XK_Control_R                     = 0xffe4,  /* Right control */
	XK_Caps_Lock                     = 0xffe5,  /* Caps lock */
	XK_Shift_Lock                    = 0xffe6,  /* Shift lock */

	XK_Meta_L                        = 0xffe7,  /* Left meta */
	XK_Meta_R                        = 0xffe8,  /* Right meta */
	XK_Alt_L                         = 0xffe9,  /* Left alt */
	XK_Alt_R                         = 0xffea,  /* Right alt */
	XK_Super_L                       = 0xffeb,  /* Left super */
	XK_Super_R                       = 0xffec,  /* Right super */
	XK_Hyper_L                       = 0xffed,  /* Left hyper */
	XK_Hyper_R                       = 0xffee,  /* Right hyper */

/*
 * Keyboard (XKB) Extension function and modifier keys
 * (from Appendix C of "The X Keyboard Extension: Protocol Specification")
 * Byte 3 = = 0xfe
 */

	XK_ISO_Lock                      = 0xfe01,
	XK_ISO_Level2_Latch              = 0xfe02,
	XK_ISO_Level3_Shift              = 0xfe03,
	XK_ISO_Level3_Latch              = 0xfe04,
	XK_ISO_Level3_Lock               = 0xfe05,
	XK_ISO_Level5_Shift              = 0xfe11,
	XK_ISO_Level5_Latch              = 0xfe12,
	XK_ISO_Level5_Lock               = 0xfe13,
	XK_ISO_Group_Shift               = 0xff7e,  /* Alias for mode_switch */
	XK_ISO_Group_Latch               = 0xfe06,
	XK_ISO_Group_Lock                = 0xfe07,
	XK_ISO_Next_Group                = 0xfe08,
	XK_ISO_Next_Group_Lock           = 0xfe09,
	XK_ISO_Prev_Group                = 0xfe0a,
	XK_ISO_Prev_Group_Lock           = 0xfe0b,
	XK_ISO_First_Group               = 0xfe0c,
	XK_ISO_First_Group_Lock          = 0xfe0d,
	XK_ISO_Last_Group                = 0xfe0e,
	XK_ISO_Last_Group_Lock           = 0xfe0f,

	XK_ISO_Left_Tab                  = 0xfe20,
	XK_ISO_Move_Line_Up              = 0xfe21,
	XK_ISO_Move_Line_Down            = 0xfe22,
	XK_ISO_Partial_Line_Up           = 0xfe23,
	XK_ISO_Partial_Line_Down         = 0xfe24,
	XK_ISO_Partial_Space_Left        = 0xfe25,
	XK_ISO_Partial_Space_Right       = 0xfe26,
	XK_ISO_Set_Margin_Left           = 0xfe27,
	XK_ISO_Set_Margin_Right          = 0xfe28,
	XK_ISO_Release_Margin_Left       = 0xfe29,
	XK_ISO_Release_Margin_Right      = 0xfe2a,
	XK_ISO_Release_Both_Margins      = 0xfe2b,
	XK_ISO_Fast_Cursor_Left          = 0xfe2c,
	XK_ISO_Fast_Cursor_Right         = 0xfe2d,
	XK_ISO_Fast_Cursor_Up            = 0xfe2e,
	XK_ISO_Fast_Cursor_Down          = 0xfe2f,
	XK_ISO_Continuous_Underline      = 0xfe30,
	XK_ISO_Discontinuous_Underline   = 0xfe31,
	XK_ISO_Emphasize                 = 0xfe32,
	XK_ISO_Center_Object             = 0xfe33,
	XK_ISO_Enter                     = 0xfe34,

	XK_dead_grave                    = 0xfe50,
	XK_dead_acute                    = 0xfe51,
	XK_dead_circumflex               = 0xfe52,
	XK_dead_tilde                    = 0xfe53,
	XK_dead_perispomeni              = 0xfe53,  /* alias for dead_tilde */
	XK_dead_macron                   = 0xfe54,
	XK_dead_breve                    = 0xfe55,
	XK_dead_abovedot                 = 0xfe56,
	XK_dead_diaeresis                = 0xfe57,
	XK_dead_abovering                = 0xfe58,
	XK_dead_doubleacute              = 0xfe59,
	XK_dead_caron                    = 0xfe5a,
	XK_dead_cedilla                  = 0xfe5b,
	XK_dead_ogonek                   = 0xfe5c,
	XK_dead_iota                     = 0xfe5d,
	XK_dead_voiced_sound             = 0xfe5e,
	XK_dead_semivoiced_sound         = 0xfe5f,
	XK_dead_belowdot                 = 0xfe60,
	XK_dead_hook                     = 0xfe61,
	XK_dead_horn                     = 0xfe62,
	XK_dead_stroke                   = 0xfe63,
	XK_dead_abovecomma               = 0xfe64,
	XK_dead_psili                    = 0xfe64,  /* alias for dead_abovecomma */
	XK_dead_abovereversedcomma       = 0xfe65,
	XK_dead_dasia                    = 0xfe65,  /* alias for dead_abovereversedcomma */
	XK_dead_doublegrave              = 0xfe66,
	XK_dead_belowring                = 0xfe67,
	XK_dead_belowmacron              = 0xfe68,
	XK_dead_belowcircumflex          = 0xfe69,
	XK_dead_belowtilde               = 0xfe6a,
	XK_dead_belowbreve               = 0xfe6b,
	XK_dead_belowdiaeresis           = 0xfe6c,
	XK_dead_invertedbreve            = 0xfe6d,
	XK_dead_belowcomma               = 0xfe6e,
	XK_dead_currency                 = 0xfe6f,

/* dead vowels for universal syllable entry */
	XK_dead_a                        = 0xfe80,
	XK_dead_A                        = 0xfe81,
	XK_dead_e                        = 0xfe82,
	XK_dead_E                        = 0xfe83,
	XK_dead_i                        = 0xfe84,
	XK_dead_I                        = 0xfe85,
	XK_dead_o                        = 0xfe86,
	XK_dead_O                        = 0xfe87,
	XK_dead_u                        = 0xfe88,
	XK_dead_U                        = 0xfe89,
	XK_dead_small_schwa              = 0xfe8a,
	XK_dead_capital_schwa            = 0xfe8b,

	XK_First_Virtual_Screen          = 0xfed0,
	XK_Prev_Virtual_Screen           = 0xfed1,
	XK_Next_Virtual_Screen           = 0xfed2,
	XK_Last_Virtual_Screen           = 0xfed4,
	XK_Terminate_Server              = 0xfed5,

	XK_AccessX_Enable                = 0xfe70,
	XK_AccessX_Feedback_Enable       = 0xfe71,
	XK_RepeatKeys_Enable             = 0xfe72,
	XK_SlowKeys_Enable               = 0xfe73,
	XK_BounceKeys_Enable             = 0xfe74,
	XK_StickyKeys_Enable             = 0xfe75,
	XK_MouseKeys_Enable              = 0xfe76,
	XK_MouseKeys_Accel_Enable        = 0xfe77,
	XK_Overlay1_Enable               = 0xfe78,
	XK_Overlay2_Enable               = 0xfe79,
	XK_AudibleBell_Enable            = 0xfe7a,

	XK_Pointer_Left                  = 0xfee0,
	XK_Pointer_Right                 = 0xfee1,
	XK_Pointer_Up                    = 0xfee2,
	XK_Pointer_Down                  = 0xfee3,
	XK_Pointer_UpLeft                = 0xfee4,
	XK_Pointer_UpRight               = 0xfee5,
	XK_Pointer_DownLeft              = 0xfee6,
	XK_Pointer_DownRight             = 0xfee7,
	XK_Pointer_Button_Dflt           = 0xfee8,
	XK_Pointer_Button1               = 0xfee9,
	XK_Pointer_Button2               = 0xfeea,
	XK_Pointer_Button3               = 0xfeeb,
	XK_Pointer_Button4               = 0xfeec,
	XK_Pointer_Button5               = 0xfeed,
	XK_Pointer_DblClick_Dflt         = 0xfeee,
	XK_Pointer_DblClick1             = 0xfeef,
	XK_Pointer_DblClick2             = 0xfef0,
	XK_Pointer_DblClick3             = 0xfef1,
	XK_Pointer_DblClick4             = 0xfef2,
	XK_Pointer_DblClick5             = 0xfef3,
	XK_Pointer_Drag_Dflt             = 0xfef4,
	XK_Pointer_Drag1                 = 0xfef5,
	XK_Pointer_Drag2                 = 0xfef6,
	XK_Pointer_Drag3                 = 0xfef7,
	XK_Pointer_Drag4                 = 0xfef8,
	XK_Pointer_Drag5                 = 0xfefd,

	XK_Pointer_EnableKeys            = 0xfef9,
	XK_Pointer_Accelerate            = 0xfefa,
	XK_Pointer_DfltBtnNext           = 0xfefb,
	XK_Pointer_DfltBtnPrev           = 0xfefc,
	$

asciimap( {
	XK_BackSpace,
	XK_Tab,
	XK_Linefeed ,
	XK_Clear,
	XK_Return,
	XK_Pause,
	XK_Scroll_Lock,
	XK_Sys_Req,
	XK_Escape,
	XK_Delete,
	$} )
