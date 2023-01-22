[map all ./Listings/more.map]
[DEFAULT REL]
BITS 64
%include "./Include/moreinc.inc"
%include "./Source/moremain.asm"
%include "./Data/moredata.asm"
;Use a 20 QWORD stack
    dq 20 dup (0)
stackTop:
    align 10h
endOfAlloc: