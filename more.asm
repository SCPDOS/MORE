[map all ./Listings/more.map]
[DEFAULT REL]
BITS 64
%include "./Include/moreInc.inc"
Segment .text align=1 
%include "./Source/moremain.asm"
%include "./Data/moredata.asm"
;Use a 45 QWORD stack
Segment transient align=8 follows=.text nobits
    dq 45 dup (?)
endOfAlloc: