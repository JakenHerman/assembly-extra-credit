

    org 100h
    
section .bss
    CR    equ    13
    NULL  equ    0
    string1    resb    75
    string2    resb    75
section .data
    max_len    db    75
    act_len    db    0
    chars      times    76    db    0
    prompt     db    "?", CR, 10, '$'
    
section .text
;print prompt for user
    mov    dx, 63
    mov    ah, 2
    int    21h
    
;input a character from keyboard into string1
    mov    cx, 0
    cld
    mov    di, string1
    mov    ah, 1
    int    21h
    
while:
	cmp    al, CR
	je     endwhile
	inc    cx
	stosb
	int    21h
	jmp    while
endwhile:
    mov    byte [di], NULL
    call   reverse
    mov    dx, string2
    call print
    jmp  over
over:    
	mov ah, 9
	int 21h
	mov ah, 4Ch
	mov al, 0
	int 21h
print:
    mov si, dx
    lodsb
    mov ah, 2
    
reverse:
    push    cx
    mov si, string1
    mov di, string2
    add di, cx
    mov byte [di], 0
    dec di
for:
	lodsb
	mov [di], al
	dec di
	loop for
	pop cx
	ret
