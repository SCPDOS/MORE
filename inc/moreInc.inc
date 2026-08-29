;Structures and equates for MORE.COM

;Table for the below packet for IOCTL 41/AX=440Ch, BX=0001h, CX=037Fh
;00h    BYTE    level (0 for DOS 4.x-6.0)
;01h    BYTE    reserved (0)
;02h    WORD    length of following data (14)
;04h    WORD    control flags
;   bit 0 set for blink, clear for intensity
;   bits 1-15 reserved
;06h    BYTE    mode type (1=text, 2=graphics)
;07h    BYTE    reserved (0)
;08h    WORD    colors -> 0000h = monochrome, 
;   else N bits per pixel/character cell (8 bits in char mode default)
;0Ah    WORD    pixel columns
;0Ch    WORD    pixel rows
;0Eh    WORD    character columns
;10h    WORD    character rows

struc displayInfoIOCTL
    .level      db ?    ;Level 0, required for DOS
    .res        db ?    ;
    .length     dw ?    ;Length of the following bytes in the struct (0014)
;The below get set by the driver if the request is supported
    .ctrlFlags  dw ?    ;Ctrl flags 
    .mode       db ?    ;Mode Type
    .res2       db ?    ;
    .colours    dw ?    ;Colours word
    .pxlCols    dw ?    ;Pixel Columns
    .pxlRows    dw ?    ;Pixel Rows
    .charCols   dw ?    ;Character Columns
    .charRows   dw ?    ;Character Rows
endstruc

;MISC ASCII control chars
NUL equ 00h ;^@         | ASCII Null
ETX equ 03h ;^C         | ASCII Break (End of Text) 
ACK equ 06h ;^F         | ASCII Acknowledgement
BEL equ 07h ;^G         | ASCII Bell
BSP equ 08h ;^H         | ASCII Backspace
TAB equ 09h ;^I         | ASCII Horizontal Tab
LF  equ 0Ah ;^J         | ASCII Line Feed
CR  equ 0Dh ;^M         | ASCII Carriage Return
DLE equ 10h ;^P         | ASCII Data Link End (Toggle Print Echo)
DC3 equ 13h ;^S         | ASCII Device Control 3 (Toggle Scroll Lock)
DC4 equ 14h ;^T         | ASCII Device Control 4
NAK equ 15h ;^U         | ASCII Negative Acknowledgement
ETB equ 17h ;^W         | ASCII End of Transmission Block
EOF equ 1Ah ;^Z         | ASCII Substitute character (End of File)
ESC equ 1Bh ;           | ASCII Escape char, used for ANSI.SYS
SPC equ 20h ;Printable  | ASCII Space
;This last one is NEVER printed with a caret as it is a console control char
DEL equ 7Fh ;^?         | ASCII Rubout (Del char and dec cursor)