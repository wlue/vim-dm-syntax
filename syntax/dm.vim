" Vim syntax file
" Language:     DM
" Maintainer:   Wen-Hao Lue <me@wenhaolue.com>
" Last Change:  2012 Dec 29

" Based on the C Syntax file.

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

let b:current_syntax = ''
unlet b:current_syntax

" Embed HTML highlighting into strings.
syntax include @HTML syntax/html.vim

syn sync fromstart

" A bunch of useful keywords
syn case match
syn keyword     dmStatement     goto break return continue
syn keyword     dmStatement     var proc verb set as new del in to global arg const tmp
syn keyword     dmConditional   if else switch
syn keyword     dmRepeat        while for do
syn keyword     dmConstant      TRUE FALSE

syn keyword     dmBuiltinTypes  world savefile
syn keyword     dmIdentifiers   src usr
syn case ignore

syn region      dmFile          start=/\v'/ end=/\v'/
syn region      dmEmbeddedExpr  start=/\[/ end=/\]/ contained contains=dmString,dmLongString,dmEmbeddedExpr

" Function names
syn match       dmFunc          /\v\w+(\s|[\\\w+\n])*\(/he=e-1

" dmCommentGroup allows adding matches for special things in comments
syn keyword     dmTodo          contained   TODO FIXME XXX
syn cluster     dmCommentGroup  contains=dmTodo

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match       dmSpecial       display contained /\v\\(ref|icon|.)/
syn region      dmString        start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=dmSpecial,@Spell,dmEmbeddedExpr
syn region      dmLongString    start=+{"+ end=+"}+ contains=dmSpecial,@Spell,dmEmbeddedExpr,@HTML


" "catch errors caused by wrong parenthesis and brackets
" " also accept <% for {, %> for }, <: for [ and :> for ] (C99)
" " But avoid matching <::.
" syn cluster   cParenGroup     contains=cParenError,dmIncluded,dmSpecial,dmCommentSkip,dmCommentString,dmComment2String,@dmCommentGroup,dmCommentStartError,cUserCont,cUserLabel,cBitField,dmOctalZero,cCppOut,cCppOut2,cCppSkip,cFormat,dmNumber,cFloat,dmOctal,dmOctalError,dmNumbersCom
" if exists("c_no_curly_error")
"   syn region  cParen          transparent start='(' end=')' contains=ALLBUT,@cParenGroup,cCppParen,cCppString,@Spell
"   " cCppParen: same as cParen but ends at end-of-line; used in dmDefine
"   syn region  cCppParen       transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cParen,dmString,@Spell
"   syn match   cParenError     display ")"
"   syn match   cErrInParen     display contained "^[{}]\|^<%\|^%>"
" elseif exists("c_no_bracket_error")
"   syn region  cParen          transparent start='(' end=')' contains=ALLBUT,@cParenGroup,cCppParen,cCppString,@Spell
"   " cCppParen: same as cParen but ends at end-of-line; used in dmDefine
"   syn region  cCppParen       transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cParen,dmString,@Spell
"   syn match   cParenError     display ")"
"   syn match   cErrInParen     display contained "[{}]\|<%\|%>"
" else
"   syn region  cParen          transparent start='(' end=')' contains=ALLBUT,@cParenGroup,cCppParen,cErrInBracket,cCppBracket,cCppString,@Spell
"   " cCppParen: same as cParen but ends at end-of-line; used in dmDefine
"   syn region  cCppParen       transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cErrInBracket,cParen,cBracket,dmString,@Spell
"   syn match   cParenError     display "[\])]"
"   syn match   cErrInParen     display contained "[\]{}]\|<%\|%>"
"   syn region  cBracket        transparent start='\[\|<::\@!' end=']\|:>' contains=ALLBUT,@cParenGroup,cErrInParen,cCppParen,cCppBracket,cCppString,@Spell
"   " cCppBracket: same as cParen but ends at end-of-line; used in dmDefine
"   syn region  cCppBracket     transparent start='\[\|<::\@!' skip='\\$' excludenl end=']\|:>' end='$' contained contains=ALLBUT,@cParenGroup,cErrInParen,cParen,cBracket,dmString,@Spell
"   syn match   cErrInBracket   display contained "[);{}]\|<%\|%>"
" endif

" Numbers:
syn case ignore
syn match       dmNumbers       display transparent "\<\d\|\.\d" contains=dmNumber,cFloat,dmOctalError,dmOctal
syn match       dmNumbersCom    display contained transparent "\<\d\|\.\d" contains=dmNumber,cFloat,dmOctal
syn match       dmNumber        display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"

" Hex number
syn match       dmNumber        display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"

" Flag the first zero of an octal number as something special
syn match       dmOctal         display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=dmOctalZero
syn match       dmOctalZero     display contained "\<0"

" Flag an octal number with wrong digits
syn match       dmOctalError    display contained "0\o*[89]\d*"
syn case match

syn region      dmCommentL      start="//" skip="\\$" end="$" keepend contains=@dmCommentGroup,@Spell
syn region      dmComment       start="/\*" end="\*/" contains=@dmCommentGroup,@Spell,dmComment extend

" Preprocessor:
syn region      dmPreCondit     start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$" end="//"me=s-1 contains=dmComment,cCppString,cCharacter,cCppParen,cParenError,dmNumbers,cSpaceError
syn match       dmPreCondit     display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"

syn region      dmIncluded      display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match       dmIncluded      display contained "<[^>]*>"
syn match       dmInclude       display "^\s*\(%:\|#\)\s*include\>\s*["<]" contains=dmIncluded
syn cluster     dmPreProcGroup  contains=dmPreCondit,dmIncluded,dmInclude,dmDefine,cErrInParen,cErrInBracket,cUserLabel,dmSpecial,dmOctalZero,cCppOut,cCppOut2,cCppSkip,cFormat,dmNumber,cFloat,dmOctal,dmOctalError,dmNumbersCom,dmString,dmCommentSkip,dmCommentString,dmComment2String,@dmCommentGroup,dmCommentStartError,cParen,cBracket,cMulti
syn region      dmDefine        start="^\s*\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" end="//"me=s-1 keepend contains=ALLBUT,@dmPreProcGroup,@Spell
syn region      dmPreProc       start="^\s*\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend contains=ALLBUT,@dmPreProcGroup,@Spell

" Labels:
syn cluster     cMultiGroup     contains=dmIncluded,dmSpecial,dmCommentSkip,dmCommentString,dmComment2String,@dmCommentGroup,dmCommentStartError,cUserCont,cUserLabel,cBitField,dmOctalZero,cCppOut,cCppOut2,cCppSkip,cFormat,dmNumber,cFloat,dmOctal,dmOctalError,dmNumbersCom,cCppParen,cCppBracket,cCppString
syn region      cMulti          transparent start='?' skip='::' end=':' contains=ALLBUT,@cMultiGroup,@Spell
" Avoid matching foo::bar() in C++ by requiring that the next char is not ':'
syn cluster     cLabelGroup     contains=cUserLabel
syn match       cUserCont       display "^\s*\I\i*\s*:$" contains=@cLabelGroup
syn match       cUserCont       display ";\s*\I\i*\s*:$" contains=@cLabelGroup
syn match       cUserCont       display "^\s*\I\i*\s*:[^:]"me=e-1 contains=@cLabelGroup
syn match       cUserCont       display ";\s*\I\i*\s*:[^:]"me=e-1 contains=@cLabelGroup

syn match       cUserLabel      display "\I\i*" contained


" Highlighting:
" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link cFormat             dmSpecial
hi def link dmCommentL          dmComment
hi def link dmComment           Comment
hi def link cLabel              Label
hi def link cUserLabel          Label
hi def link dmConditional       Conditional
hi def link dmRepeat            Repeat
hi def link dmSpecialCharacter  dmSpecial
hi def link dmNumber            Number
hi def link dmOctal             Number
hi def link dmOctalError        dmError
hi def link cParenError         dmError
hi def link cErrInParen         dmError
hi def link cErrInBracket       dmError
hi def link dmInclude           Include
hi def link dmPreProc           PreProc
hi def link dmDefine            Macro
hi def link dmIncluded          dmString
hi def link dmError             Error
hi def link dmStatement         Statement
hi def link dmPreCondit         PreCondit
hi def link dmConstant          Constant
hi def link dmString            String
hi def link dmFile              String
hi def link dmLongString        String
hi def link dmSpecial           SpecialChar
hi def link dmTodo              Todo
hi def link dmEmbeddedExpr      Type
" hi def link dmBuiltinTypes      Identifier
" hi def link dmIdentifiers       Identifier
" hi def link dmFunc              Function


let b:current_syntax = "dm"

