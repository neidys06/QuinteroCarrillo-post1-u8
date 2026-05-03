; p1d.asm - REPE CMPSB: comparacion de cadenas
; Compilar: ..\nasm -f bin p1d.asm -o ..\bin\p1d.com
; REPE CMPSB: compara byte a byte DS:SI con ES:DI mientras ZF=1 y CX>0
; Al terminar: ZF=1 = cadenas iguales en los CX bytes comparados
;              ZF=0 = SI y DI apuntan al byte SIGUIENTE al primer diferente

ORG 100h

section .data
    cad1   db "NASM x86",0    ; cadena 1
    cad2   db "NASM x86",0    ; cadena 2 (igual a cad1)
    cad3   db "NASM ARM",0    ; cadena 3 (diferente en pos 5: 'x' vs 'A')
    msgIg  db "Iguales.$"
    msgDif db "Diferentes.$"
    crlf   db 0Dh,0Ah,"$"

section .text
start:
    ; Preparar ES = DS (CMPSB usa DS:SI y ES:DI)
    mov ax, ds
    mov es, ax

    ; ==========================================
    ; CASO 1: cad1 vs cad2 -> deben ser IGUALES
    ; ==========================================
    mov si, cad1
    mov di, cad2
    mov cx, 8           ; comparar 8 bytes
    cld                 ; DF=0: avance hacia adelante

    repe cmpsb          ; repite mientras bytes iguales (ZF=1) y CX>0

    je .iguales1        ; ZF=1 al terminar -> son iguales
    ; Si llega aqui son diferentes
    mov ah, 09h
    mov dx, msgDif
    int 21h
    jmp .separador1
.iguales1:
    mov ah, 09h
    mov dx, msgIg
    int 21h

.separador1:
    mov ah, 09h
    mov dx, crlf
    int 21h

    ; =============================================
    ; CASO 2: cad1 vs cad3 -> deben ser DIFERENTES
    ; CMPSB se detiene en pos 5 donde 'x' != 'A'
    ; =============================================
    mov si, cad1
    mov di, cad3
    mov cx, 8
    cld

    repe cmpsb

    je .iguales2
    mov ah, 09h
    mov dx, msgDif
    int 21h
    jmp .fin
.iguales2:
    mov ah, 09h
    mov dx, msgIg
    int 21h

.fin:
    mov ah, 09h
    mov dx, crlf
    int 21h

    mov ah, 4Ch
    xor al, al
    int 21h