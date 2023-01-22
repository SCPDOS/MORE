;MORE main routine
startMain:
    jmp short .cVersion
.vNum:  db 1
.cVersion:
    lea rsp, stackTop   ;Move RSP to our internal stack
;Do a version check since this version cannot check the number of rows/cols
    cld
    mov ah, 30h
    int 41h
    cmp al, byte [.vNum]    ;Version number 1 check
    jbe short okVersion
    lea rdx, badVerStr
badPrintExit:
    mov ah, 09h
    int 41h
    mov eax, 4CFFh
    int 41h
okVersion:
;Now try to get screen size parameters from STDOUT.
; If generic IOCTL not supported, we assume a 80x25 resolution.
    lea rdx, ioctlPkt   ;Struct is already zeroed
    mov word [rdx + displayInfoIOCTL.length], 14    ;Set block length
    mov eax, 440Ch  ;Generic IOCTL
    mov ebx, 1      ;STDOUT handle
    mov ecx, 037Fh  ;Can this handle handle CON requests? (CH = 03)
    ;If so, can we get the display info? (CL = 7Fh)
    int 41h
    jc short noioctl
    movzx eax, word [rdx + displayInfoIOCTL.charCols]
    mov word [numCols], ax
    movzx eax, word [rdx + displayInfoIOCTL.charRows]
    mov word [numRows], ax
noioctl:
    lea rdx, crlf
    mov eax, 0900h
    int 41h

    xor ebx, ebx
    mov eax, 4500h  ;Dup STDIN
    int 41h
    movzx ebp, ax   ;Save in bp to use this as read handle
    
    mov eax, 4600h  ;Close STDIN and dup STDERR into STDIN
    mov ebx, 2      ;Handle to DUP (STDERR)
    xor ecx, ecx    ;Dup to STDIN for console control
    int 41h
;Now let us resize ourselves so as to take up as little memory as possible
    mov ebx, endOfAlloc
    mov eax, 4A00h
    int 41h ;If this fails, we still proceed as we are just being polite!
;Now we now request a 4Kb buffer
    mov eax, 4800h
    mov ebx, 100h   ;100h paragraphs = 4Kb buffer
    int 41h
    jnc memOk
    lea rdx, memErrStr
    jmp badPrintExit
memOk:
    mov qword [bufferPtr], rax
bufferLoop:
    mov rdx, qword [bufferPtr]  ;Get ptr to buffer
    mov ecx, 1000h
    mov ebx, ebp
    mov eax, 3F00h  ;Read from handle in ebp
    int 41h
    test eax, eax ;Zero byte read?
    jnz short setReadSize
exitGood:
    mov r8, qword [bufferPtr]
    test r8, r8 ;If null ptr, skip freeing
    jz .noFree
    mov eax, 4900h  ;Else free!
    int 41h
.noFree:
    mov eax, 4C00h
    int 41h
setReadSize:
    mov ecx, eax    ;Set the number of bytes to output
    mov rsi, rdx    ;Move rsi as the source of chars
getNextChar:
    lodsb   ;Get char
    cmp al, EOF
    je short exitGood
    ;Now handle control chars as needed before going onto next char
    cmp al, CR
    jne short notCr
    mov word [curCol], 1
    jmp short ctrlFound
notCr:
    cmp al, LF
    jne short notLf
    inc word [curRow]
    jmp short ctrlFound
notLf:
    cmp al, BSP
    jne short notBsp
    cmp word [curCol], 1    ;If at top left, dont go back
    je short ctrlFound
    dec word [curCol]
    jmp short ctrlFound
notBsp:
    cmp al, TAB
    jne short notTab
    push rax
    movzx eax, word [curCol]
    add eax, 7  ;Round up to next tabstop
    and eax, ~7 ;Now divide by 8
    inc eax
    mov word [curCol], ax
    pop rax 
    jmp short ctrlFound
notTab:
    cmp al, BEL
    je short ctrlFound
    ;Here we have a normal char so treat as normal
    inc word [curCol]
    push rax
    movzx eax, word [curCol]
    cmp ax, word [numCols]
    pop rax
    jbe short ctrlFound
    inc word [curRow]
    mov word [curCol], 1    ;Reset column
ctrlFound:
    mov dl, al
    mov eax, 0200h  ;Output char in dl
    int 41h
    push rax
    movzx eax, word [curRow]
    cmp ax, word [numRows]
    pop rax
    jb short noMessage
    lea rdx, moreStr
    mov eax, 0900h  
    int 41h
    mov eax, 0C08h  ;Flush and wait for input with no echo
    int 41h
    lea rdx, crlf
    mov eax, 0900h
    int 41h
    mov word [curCol], 1
    mov word [curRow], 1
noMessage:
    dec ecx ;Decrement the count of chars to print
    jz bufferLoop   ;Get another buffer of data if buffer output
    jmp getNextChar