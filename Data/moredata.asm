;MORE data
;Default size is 80x25 unless overwritten by successful IOCTL request
numCols dw 80   ;Number of columns as a word, for high resolutions!
numRows dw 25   ;Number of rows as a word! Reserve row 25 for -- MORE --
curCol  dw 1    ;Current Column we are on
curRow  dw 1    ;Current Row we are on 

ioctlPkt    db displayInfoIOCTL_size dup (0)

;Strings
badVerStr   db "Invalid DOS Version"    ;Ends on the next line
crlf        db LF,CR,"$"
moreStr     db CR,"-- More --$"
memErrStr   db "Not enough memory to paginate",LF,CR,"$"

bufferPtr   dq 0