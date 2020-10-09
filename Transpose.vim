function Transpose(offset, ...) range
	" Transposes the music in the range (default current row)
	" Per default uses sharps -- if given a second argument 'flats', uses flats
	" As a first step converts all double sharps and flats, as well as
	" augmentations and lowered tones between white keys to their
	" sounding doubles -- don't use if you care about music theory.
	let sign = get(a:, 1, 'sharps') ==? 'flats' ? 1 : 0
	let rng = a:firstline.','.a:lastline

	" Switch through languages. The default, nederlands, is last
	" https://github.com/lilypond/lilypond/blob/master/scm/define-note-names.scm
	" TODO add deutsch, english, español, français, italiano, norsk,
	" português, suomi, svenska, vlaams, arabic
	" or, better, automatically get this from the scm file...
	" Every row corresponds to a preferred signature, and every column
	" should contain different names for the same sounding note
	if g:LilypondLanguage == 'català'
		let notenames = [
					\ [ 'do', 'dod', 're', 'red', 'mi', 'fa', 'fad', 'sol', 'sold', 'la', 'lad', 'si' ],
					\ [ 'do', 'reb', 're', 'mib', 'mi', 'fa', 'solb', 'sol', 'lab', 'la', 'sib', 'si' ],
					\ [ 'sid', 'sidd', 'dodd', 'mib', 'redd', 'mid', 'midd', 'fadd', 'sold', 'soldd', 'lad', 'ladd' ],
					\ [ 'rebb', 'reb', 'mibb', 'fabb', 'fab', 'solbb', 'solb', 'labb', 'lab', 'sibb', 'dobb', 'dob' ]
		]
	else # Default: nederlands
		let notenames= [
					\ [ 'c', 'cis', 'd', 'dis', 'e', 'f', 'fis', 'g', 'gis', 'a', 'ais', 'b' ],
					\ [ 'c', 'des', 'd', 'es', 'e', 'f', 'ges', 'g', 'aes', 'a', 'bes', 'b' ],
					\ [ 'bis',   'bisis', 'cisis', 'ees',   'disis', 'eis',   'eisis', 'fisis', 'gis', 'gisis', 'ais',   'aisis'  ], 
					\ [ 'deses', 'des',   'eeses', 'feses', 'fes',   'geses', 'ges',   'aeses', 'aes', 'beses', 'ceses', 'ces'    ] 
					\ ]
	end

	let suffixes = ":~(,'=0-9\^\\\\>* "

	" escape § signs with a backslash
	execute rng.'s/§/\\§/ge'
	for j in range(len(notenames))
		for i in range(len(notenames[j]))
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
