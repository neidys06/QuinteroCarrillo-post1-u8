; p1a.asm - REP MOVSB y REP MOVSW: copia de cadena
ORG 100h

origen   db "HOLA, MUNDO!"
destino  db 0,0,0,0,0,0,0,0,0,0,0,0,"$"
destino2 db 0,0,0,0,0,0,0,0,0,0,0,0,"$"
msgCop1  db "MOVSB: $"
msgCop2  db "MOVSW: $"
crlf     db 0Dh,0Ah,"$"

start:
    mov ax, ds
    mov es, ax

    ; --- PASO 1: copia con REP MOVSB ---
    ; SI=fuente, DI=destino, CX=12 bytes, DF=0
    mov si, origen
    mov di, destino
    mov cx, 12
    cld
    rep movsb

    mov ah, 09h
    mov dx, msgCop1
    int 21h
    mov dx, destino
    int 21h
    mov dx, crlf
    int 21h

    ; --- PASO 2: copia optimizada con REP MOVSW ---
    ; MOVSW copia 2 bytes por iteracion (mas eficiente)
    ; CX = 12/2 = 6 words; no hay byte impar
    mov si, origen
    mov di, destino2
    mov cx, 6
    cld
    rep movsw

    mov ah, 09h
    mov dx, msgCop2
    int 21h
    mov dx, destino2
    int 21h
    mov dx, crlf
    int 21h

    mov ah, 4Ch
    xor al, al
    int 21h