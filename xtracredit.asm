;input a string & store it in a buffer
;copy that string in reverse into another buffer
;output the second string just to check
;compare the two strings to see if they are palindromes


;palindrome program
          org 100h

section .bss
        CR       equ        13
        NULL     equ        0
        string1 resb        80
        string2 resb        80

section .data
        CRLF        db        CR, 10, '$'
        prompt      db        "?", CR, 10, '$'


section .text
      mov dx, prompt
       mov ah, 9
       int 21h

;input a char from kbd into string1
        mov     cx, 0
        cld         ;process string left to right
        mov     di, string1       ;string1 is destination
        mov     ah, 1             ;read char fcn
        int     21h               ;read it
while1:
        cmp     al, CR            ;is char = CR?
        je      endwhile1          ;if so, we're done
        inc     cx
        stosb                     ;store char just read into string1
        int     21h               ;read next char
        jmp     while1            ;loop until done
endwhile1:
        mov     byte [di], NULL      ;store ASCII null char

        call    reverse           ;copies string1 into string2 reversed
        mov     dx, string2
        call    print             ;print the reversed string

        mov     si, string1
        mov     di, string2
        repe    cmpsb             ;compare two strings

        cmp     cx, 0             ;did we reach end of string?
        jmp     over
over:   mov     ah, 9             ;print string fcn
        int     21h

        mov     ah, 4Ch           ;return to DOS fcn
        mov     al, 0             ;normal termination
        int     21h               ;exit to DOS.

print:
        mov     si, dx            ;set up for lodsb
        lodsb                     ;read first char into al
        mov     ah, 2             ;display char fcn

while2:
        cmp     al, NULL          ;is it a NULL char?
        je      endwhile2         ;if so, we're done
        mov     dl, al            ;set up for display
        int     21h               ;display the character
        lodsb                     ;read next char
        jmp     while2            ;loop until done
endwhile2:
        ;print CR/LF pair
        mov     dx, CRLF
        mov     ah, 9             ;print string fcn
        int     21h
        ret

reverse:
        push    cx
        mov     si, string1       ;setup source
        mov     di, string2
        add     di,cx             ;setup di to point to end of dest
        mov     byte[di], 0       ;mark the end of the string
        dec     di
for1:
        lodsb                     ;copy source into al
        mov     [di], al           ;store into dest
        dec     di
        loop    for1
        pop     cx
        ret
