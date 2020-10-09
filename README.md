# LilyVimTranspose
Transpose function for Lilypond music in Vim

`:4,7Transpose(3)` transposes all notes from line 4 to 7 up by 3 half notes.
`:Transpose(-2,'flats')` transposes current line by a whole step, preferring to write flats over sharps.

This function does not preserve musical finesse: It does not treat `cisis` differently from `d`.

Your input language can be set by setting the variable `g:LilypondLanguage`. The default is `nederlands`. Currently only `nederlands` and `catalàn` are implemented -- let me know if you want some specific language.
