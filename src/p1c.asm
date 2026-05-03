; p1c.asm - REPNE SCASB: buscar caracter en cadena
; Compilar: ..\nasm -f bin s\p1c.asm -o b\p1c.com
; REPNE SCASB: compara AL con ES:DI, avanza DI mientras ZF=0 y CX>0
; Al terminar: ZF=1 = encontrado, DI apunta al byte SIGUIENTE al hallado
; Registros: AL=caracter buscado, DI=puntero cadena, CX=longitud

ORG 100h

section .data
    cadena  db "Arquitectura de Computadores",0
    longCad equ 28              ; longitud sin el nulo
    msgHall db "Hallado en posicion: $"
    msgNoH  db "No encontrado.$"
    crlf    db 0Dh,0Ah,"$"

section .text
start:
    ; Preparar ES = DS (SCASB usa ES:DI como destino de busqueda)
    mov ax, ds
    mov es, ax

    ; Cargar puntero al inicio de la cadena en DI
    mov di, cadena

    ; Caracter a buscar: 'd' (minuscula, ASCII 64h)
    ; En "Arquitectura de Computadores", 'd' esta en posicion 14
    mov al, 'z'

    ; Longitud maxima de busqueda
    mov cx, longCad

    ; DF=0: DI avanza hacia adelante
    cld

    ; REPNE SCASB: repite mientras ZF=0 (no encontrado) y CX>0
    repne scasb

    ; Si ZF=0 al terminar -> CX se agoto sin encontrar
    jne .noHallado

    ; --- Caracter encontrado ---
    ; DI ahora apunta al byte SIGUIENTE al encontrado
    ; Posicion base-0 = DI_actual - direccion_inicio - 1
    mov bx, di
    sub bx, cadena      ; BX = desplazamiento desde inicio + 1
    dec bx              ; BX = posicion base-0 del caracter hallado

    ; Imprimir mensaje "Hallado en posicion: "
    mov ah, 09h
    mov dx, msgHall
    int 21h

    ; Convertir posicion a dos digitos decimales ASCII e imprimir
    ; BX puede ser > 9, asi que imprimimos decenas y unidades
    mov ax, bx          ; AX = posicion (puede ser 0-28)
    mov bl, 10
    div bl              ; AL = decenas, AH = unidades
    ; Imprimir decena (solo si != 0, para no mostrar "0" innecesario)
    test al, al
    jz .soloUnidad
    add al, 30h         ; convertir a ASCII
    mov dl, al
    mov ah, 02h
    int 21h
.soloUnidad:
    mov al, ah          ; unidades
    add al, 30h
    mov dl, al
    mov ah, 02h
    int 21h

    mov ah, 09h
    mov dx, crlf
    int 21h
    jmp .fin

.noHallado:
    mov ah, 09h
    mov dx, msgNoH
    int 21h
    mov dx, crlf
    int 21h

.fin:
    mov ah, 4Ch
    xor al, al
    int 21h