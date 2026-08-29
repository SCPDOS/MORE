[map all ./lst/more.map]
[DEFAULT REL]
BITS 64
%include "./inc/moreInc.inc"
Segment .text align=1 
%include "./src/moremain.asm"
%include "./data/moredata.asm"
;Use a 45 QWORD stack
Segment transient align=8 follows=.text nobits
    dq 45 dup (?)
endOfAlloc: