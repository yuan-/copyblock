" Copies the visual selection with the filename and line number. Indents are
" removed.
"
" https://github.com/euoia/copyblock
function! CopyBlock() range
    let l:title = expand('%')
    let l:title .= " line " . getpos("'<")[1]

    " http://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let l:lines = getline(lnum1, lnum2)
    let l:lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let l:lines[0] = lines[0][col1 - 1:]

    " Shift text over to left until first line is no longer indented.
    while match(l:lines[0], '^\s') == 0
        for l:lineNum in range(0, len(l:lines) - 1)
            let l:line = l:lines[l:lineNum]
            let l:lines[l:lineNum] = substitute(l:line, '^\s', '', '')
        endfor
    endwhile

    let l:joinedLines = join(l:lines, "\n")
    let @* = l:title . "\n" . l:joinedLines

    let numLinesCopied = (lnum2 - lnum1) + 1

    " Use redraw here so the message shows.
    redraw
    if numLinesCopied == 1
        echo "1 line copied"
    else
        echo numLinesCopied . " lines copied"
    endif
endfunction
