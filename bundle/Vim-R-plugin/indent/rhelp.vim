" Vim indent file
" Language:	R Documentation (Help), *.Rd
" Author:	Jakson Alves de Aquino <jalvesaq@gmail.com>
" URL:		http://www.vim.org/scripts/script.php?script_id=2628
" Last Change:	Fri Feb 15, 2013  09:46PM


" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
runtime indent/r.vim
let b:did_indent = 1

setlocal indentkeys=0{,0},:,!^F,o,O,e
setlocal indentexpr=GetRHelpIndent()

" Only define the function once.
if exists("*GetRHelpIndent")
    finish
endif

setlocal noautoindent
setlocal nocindent
setlocal nosmartindent
setlocal nolisp

setlocal indentkeys=0{,0},:,!^F,o,O,e
setlocal indentexpr=GetCorrectRHelpIndent()

function s:SanitizeRHelpLine(line)
    let newline = substitute(a:line, '\\\\', "x", "g")
    let newline = substitute(newline, '\\{', "x", "g")
    let newline = substitute(newline, '\\}', "x", "g")
    let newline = substitute(newline, '\\%', "x", "g")
    let newline = substitute(newline, '%.*', "", "")
    let newline = substitute(newline, '\s*$', "", "")
    return newline
endfunction

function GetRHelpIndent()

    let clnum = line(".")    " current line
    if clnum == 1
        return 0
    endif
    let cline = getline(clnum)

    if cline =~ '^\s*}\s*$'
        let i = clnum
        let bb = -1
        while bb != 0 && i > 1
            let i -= 1
            let line = s:SanitizeRHelpLine(getline(i))
            let line2 = substitute(line, "{", "", "g")
            let openb = strlen(line) - strlen(line2)
            let line3 = substitute(line2, "}", "", "g")
            let closeb = strlen(line2) - strlen(line3)
            let bb += openb - closeb
        endwhile
        return indent(i)
    endif

    if cline =~ '^\s*#ifdef\>' || cline =~ '^\s*#endif\>'
        return 0
    endif

    let lnum = clnum - 1
    let line = getline(lnum)
    if line =~ '^\s*#ifdef\>' || line =~ '^\s*#endif\>'
        let lnum -= 1
        let line = getline(lnum)
    endif
    while lnum > 1 && (line =~ '^\s*$' || line =~ '^#ifdef' || line =~ '^#endif')
        let lnum -= 1
        let line = getline(lnum)
    endwhile
    if lnum == 1
        return 0
    endif
    let line = s:SanitizeRHelpLine(line)
    let line2 = substitute(line, "{", "", "g")
    let openb = strlen(line) - strlen(line2)
    let line3 = substitute(line2, "}", "", "g")
    let closeb = strlen(line2) - strlen(line3)
    let bb = openb - closeb

    let ind = indent(lnum) + (bb * &sw)

    if line =~ '^\s*}\s*$'
        let ind = indent(lnum)
    endif

    if ind < 0
        return 0
    endif

    return ind
endfunction

function GetCorrectRHelpIndent()
    let lastsection = search('^\\[a-z]*{', "bncW")
    let secname = getline(lastsection)
    if secname =~ '^\\usage{' || secname =~ '^\\examples{' || secname =~ '^\\dontshow{' || secname =~ '^\\dontrun{' || secname =~ '^\\donttest{' || secname =~ '^\\testonly{' || secname =~ '^\\method{.*}{.*}('
        return GetRIndent()
    else
        return GetRHelpIndent()
    endif
endfunction

" vim: sw=4
