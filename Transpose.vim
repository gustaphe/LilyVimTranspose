function Transpose(offset, ...) range
	" Transposes the music in the range (default current row)
	" Per default uses sharps -- if given a second argument 'flats', uses flats
	" As a first step converts all double sharps and flats, as well as
	" augmentations and lowered tones between white keys to their
	" sounding doubles -- don't use if you care about music theory.
	let sign = get(a:, 1, 'sharps') ==? 'flats' ? 1 : 0
	let rng = a:firstline.','.a:lastline
	" Every row corresponds to a preferred signature, and every column
	" should contain different names for the same sounding note
	let notenames = [ 
				\ [ 'c',     'cis',   'd',     'dis',   'e',     'f',     'fis',   'g',     'gis', 'a',     'ais',   'b'      ], 
				\ [ 'c',     'des',   'd',     'es',   'e',     'f',     'ges',   'g',     'aes',  'a',     'bes',   'b'      ], 
				\ [ 'bis',   'bisis', 'cisis', 'ees',   'disis', 'eis',   'eisis', 'fisis', 'gis', 'gisis', 'ais',   'aisis'  ], 
				\ [ 'deses', 'des',   'eeses', 'feses', 'fes',   'geses', 'ges',   'aeses', 'aes', 'beses', 'ceses', 'ces'    ] 
				\ ]
	let suffixes = ":~(,'=0-9\^\\\\>* "

	" escape § signs with a backslash
	execute rng.'s/§/\\§/ge'
	for i in range(12)
		for j in range(4)
			execute rng.'s/\<'.notenames[j][i].'\(['.suffixes.']\|$\)\@=/§'.notenames[sign][(i+a:offset)%12].'§/ge'
		endfor
	endfor
	" Remove all § signs not preceded by backslash
	execute rng.'s/\(\\\)\@<!§//ge'
	" unescape § signs
	execute rng.'s/\\§/§/ge'
endfunction

command -nargs=+ -range Transpose
			\ :execute <line1>.",".<line2>."call Transpose(<f-args>)"
