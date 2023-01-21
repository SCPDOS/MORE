[map all ./Listings/sys.map]
[DEFAULT REL]
BITS 64
%include "./Include/dosMacro.mac"
%include "./Include/dosStruc.inc"
%include "./Include/fatStruc.inc"
%include "./Include/dosError.inc"

struc sysInitTableStruc
    .length     resb 1
    .numSec     resb 1
    .resWord    resb 2
    .firstLba   resb 8
;---------The below is added for convenience----------
    .bootable   resb 1  ;Flag to indicate bootable
endstruc

%include "./Source/moremain.asm"
%include "./Data/moredata.asm"