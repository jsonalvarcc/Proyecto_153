.MODEL SMALL
.STACK 100H
.DATA
    menu db " cmd CMD Descripcion",13,10,"  b   B   Fibonacci",13,10,"  f   F   Factorial",13,10,"  v   V   Maximo Comun Divisor",13,10,"  m   M   Minimo Comun Multiplo",13,10,"  d   D   Divisores",13,10,"  p   P   Primos Menores a",13,10,"  e   E   Es Primo?",13,10,"  c   C   Cuadrado",13,10,"  u   U   Cubo",13,10,"  t   T   Potencia",13,10,"  r   R   Raiz Cuadrada",13,10,"  z   Z   Raiz",13,10,"  x   X   Promedio",13,10,"  l   L   Numero Feliz",13,10,"  n   N   Numero Perfecto",13,10,"",13,10,"         * Muestra el Menu$"
    nohayParametros db "Sin parametro$"
    msg_invalido db "Parametro invalido$", 0
    msgPrimo db "Es primo$", 0
    no_msgPrimo db "No es primo$", 0     
    numero dw 0  
    resultadoFacto dw 1       
    mensajeFactorial db 'Factorial: $'
    salto_linea db 13, 10, '$'
    buffer dw 6 dup(0)   
    divisor dw 1          
    contadorDivisores dw 0
    ponerEspacio db ' $'
    msgTotalDivisors db ' Total de Divisores: $'
    cuadrado dw 0
    msgSobrePasa db "El numero ingresado, operando Sobrepasa 16 bits.$"
    estadoPrimo db 0
    var_i dw 0
    auxNum dw 0
    base dw 0
    expo dw 0
    msgPerfecto db 'El numero es perfecto$'
    msgNoPerfecto db 'El numero no es perfecto$'
    ceroo db "0"
    cont db 0 
    MCM db 0 
    MCD db 0 
    num1 dw 0 
    num2 dw 0 
    resultado dw 0
    epsilon dw 1              
    iteraciones dw 10
    msgFeliz db "Numero Feliz$"
    msgNo_Feliz db "No es Numero Feliz$"


.CODE
start:
    ; Inicializa los segmentos de datos
    mov ax, @data
    mov ds, ax

    ; Obtener el segmento del PSP (Program Segment Prefix)
    mov ah, 62h
    int 21h
    mov es, bx  ; ES ahora apunta al PSP

    ; Obtener la longitud de los parámetros de la línea de ponerEspaciondos
    mov al, es:[80h]
    cmp al, 0
    je no_parametros

    ; Saltar el byte de longitud
    mov si, 81h
;saltarse espacios para reconocr el parametro
ignorarEspacios:
    cmp byte ptr es:[si], ' '; zz                 x
    jne primer_Parametro
    inc si
    jmp ignorarEspacios

primer_Parametro:
    mov al, es:[si]
    cmp al, 'b'
    je verifica_parametro_b; fibonacci
    cmp al, 'B'
    je verifica_parametro_b
    cmp al,'f'
    je verifica_parametro_f ;factorial
    cmp al,'F'
    je verifica_parametro_f 
    cmp al,'v'
    je verifica_parametro_v;Maximo comun Divisor
    cmp al,'V'
    je verifica_parametro_v
    cmp al,'m'
    je verifica_parametro_m;Minimo Comun Multiplo
     cmp al,'M'
    je verifica_parametro_m
    cmp al, 'e'
    je verifica_Parametro_e ;es primo?
    cmp al, 'E'
    je verifica_Parametro_e      
    cmp al, 'd'
    je verifica_parametro_d ;divisores
    cmp al, 'D'
    je verifica_parametro_d
    cmp al, 'c'
    je verifica_parametro_c ;cuadrado
    cmp al, 'C'
    je verifica_parametro_c
    cmp al, 'p'
    je verifica_parametro_p ;Primos menores a
    cmp al, 'P'
    je verifica_parametro_p
    cmp al, 'u'
    je verifica_parametro_u ; Cubo
    cmp al, 'U'
    je verifica_parametro_u     
    cmp al, 't'
    je verifica_parametro_t; Potencia
    cmp al, 'T'
    je verifica_parametro_t
    cmp al, 'n'
    je verifica_parametro_n;Numro perfecto
    cmp al, 'N'
    je verifica_parametro_n
    cmp al, 'r'
    je verifica_parametro_r:;raiz Cuadrada
    cmp al, 'R'   
    je verifica_parametro_r
    cmp al, 'z'   
    je verifica_parametro_z;raiz
    cmp al, 'Z'   
    je verifica_parametro_z;raiz
    cmp al, 'l'   
    je verifica_parametro_l;numero feliz
    cmp al, 'L'   
    je verifica_parametro_l
    cmp al, 'x'   
    je verifica_parametro_x;Promedio
     cmp al, 'X'   
    je verifica_parametro_x
    cmp al,'*'
    je desplegar_menu
    jmp invalido_parametro
;Promedio x X
verifica_parametro_x:
    inc si
pasarseEspacio_x: ;zz  x    
    cmp byte ptr es:[si], ' '
    jne segundo_parametro_x
    inc si
    jmp pasarseEspacio_x

segundo_parametro_x:  
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10     
    call CONVERTIR_PARAMETRO_NUMERO        
    cmp ax, 32000      
    ja sobrepasa
    mov  num1, ax   
    jmp verifica_Tercer_parametro_x

verifica_Tercer_parametro_x: 

    pasarseEspacio_tercer_x:
        cmp byte ptr es:[si], ' '
        jne tercer_parametro_x
        inc si
        jmp pasarseEspacio_tercer_x

    tercer_parametro_x:
        xor ax, ax
        xor bx, bx                                   
        mov cx, 10     
        call CONVERTIR_PARAMETRO_NUMERO        
        cmp ax, 32000       
        ja sobrepasa
        mov  num2, ax  
        xor ax,ax
        mov ax,num1
        add ax,num2 
        xor bx,bx
        mov bx,2
        div bx
        mov ax,ax 
        call imprimirNumero
        mov dx, offset ponerEspacio
        call ImprimiString
        jmp SALIR_PROGRAMA
;numero feliz l L
verifica_parametro_l:
    inc si
pasarseEspacio_l:
    cmp byte ptr es:[si], ' '
    jne segundo_parametro_l
    inc si
    jmp pasarseEspacio_l

segundo_parametro_l:  
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10     
    call CONVERTIR_PARAMETRO_NUMERO        
    cmp ax, 65000      
    ja sobrepasa
    mov  numero, ax   
    mov cx, 0  
    check_Feliz:
        call suma_cuadrados  
        mov dx, ax  
        mov ax, 0  
    vri_repticion:
        test dx, dx  ;
        jz Feliz  
        cmp dx, 1  
        je Feliz  
        mov ax, dx  
        mov dx, 0 
        call suma_cuadrados  
        inc cx 
        cmp cx, 50  
        jge no_Feliz  
        jmp vri_repticion

    suma_cuadrados:
        xor bx, bx  
        mov ax, numero  
    sum_digits:
        mov cx, ax  
        and cx, 0FH  ; Mascara para obtener solo el dígito (parte baja)
        mov dx, cx  
        xor cx, cx  
        imul dx 
        add bx, ax  
        mov ax, cx  
        shr ax, 4  ; Desplazar el byte a la derecha para obtener el siguiente dígito
        test ax, ax  
        jnz sum_digits 
        mov ax, bx  
        ret

    Feliz:
        lea dx, msgFeliz
        mov ah, 9
        int 21h
        jmp SALIR_PROGRAMA

    no_Feliz:
        lea dx, msgNo_Feliz
        mov ah, 9
        int 21h
        jmp SALIR_PROGRAMA
    
;raiz z Z
verifica_parametro_z:
    inc si
pasarseEspacio_z:
    cmp byte ptr es:[si], ' '
    jne segundo_parametro_z
    inc si
    jmp pasarseEspacio_z

segundo_parametro_z:  
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10     
    call CONVERTIR_PARAMETRO_NUMERO        
    cmp ax, 65000      
    ja sobrepasa
    mov  numero, ax   
    mov ax, numero        
    mov cx, 2
    div cx
    mov bx, ax           

    aproximar:
        mov ax, numero
        mov dx, 0
        div bx                 
        add ax, bx            
        mov dx, 0
        mov cx, 2
        div cx                

        cmp ax, bx
        je terminado          
        mov bx, ax             
        jmp aproximar

    terminado:
        mov resultado, ax
        mov ax, resultado
        call imprimirNumero
        mov dx, offset ponerEspacio
        call ImprimiString
        jmp SALIR_PROGRAMA





; mminimo comun Multiplo m M
verifica_parametro_m:
    inc si
pasarseEspacio_m:
    cmp byte ptr es:[si], ' '
    jne segundo_parametro_m
    inc si
    jmp pasarseEspacio_m

segundo_parametro_m:  
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10     
    call CONVERTIR_PARAMETRO_NUMERO        
    cmp ax, 65000      
    ja sobrepasa
    mov  num1, ax   
    jmp verifica_Tercer_parametro_m

    verifica_Tercer_parametro_m: 

        pasarseEspacio_tercer_m:
            cmp byte ptr es:[si], ' '
            jne tercer_parametro_m
            inc si
            jmp pasarseEspacio_tercer_m

        tercer_parametro_m:
            xor ax, ax
            xor bx, bx                                   
            mov cx, 10     
            call CONVERTIR_PARAMETRO_NUMERO        
            cmp ax, 65000       
            ja sobrepasa
            mov  num2, ax   
            ;algoritmo 
            mov ax, num1    
            mov bx, num2   

    ; Algoritmo de Euclides para calcular el MCD
    bucleMCD:
        cmp bx, 0   
        je finMCD      
        mov dx, 0    
        div bx       ; Dividir ax por bx (DX:ax / bx => ax = ax / bx, DX = ax mod bx)
        mov ax, bx   
        mov bx, dx  
        jmp bucleMCD  

    finMCD:
 
    mov resultado, ax  ; El resultado final está en ax (MCD)
    ; Calcular el MCM utilizando la fórmula: MCM(a, b) = (a * b) / MCD(a, b)
    mov ax, num1        ; Cargar el primer número en ax
    imul num2           ; Multiplicar ax por el segundo número (resultado en ax)
    idiv resultado      ; Dividir el resultado por el MCD (resultado en ax)

    mov ax, ax  ; El resultado final está en ax (MCM) 
    call imprimirNumero
    mov dx, offset ponerEspacio
    call ImprimiString
    jmp SALIR_PROGRAMA




;Maximo comun Divisor v V
verifica_parametro_v:
    inc si
pasarseEspacio_v:
    cmp byte ptr es:[si], ' '
    jne segundo_parametro_v
    inc si
    jmp pasarseEspacio_v

segundo_parametro_v:  
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10     
    call CONVERTIR_PARAMETRO_NUMERO        
    cmp ax, 65000      
    ja sobrepasa
    mov  num1, ax   
    jmp verifica_Tercer_parametro_v

verifica_Tercer_parametro_v: 

    pasarseEspacio_tercer_v:
        cmp byte ptr es:[si], ' '
        jne tercer_parametro_v
        inc si
        jmp pasarseEspacio_tercer_v

    tercer_parametro_v:
        xor ax, ax
        xor bx, bx                                   
        mov cx, 10     
        call CONVERTIR_PARAMETRO_NUMERO        
        cmp ax, 65000       
        ja sobrepasa
        mov  num2, ax   
        ;algoritmo 
         mov ax, num1     ; Cargar el primer número en ax
    mov bx, num2     ; Cargar el segundo número en bx

    ; Algoritmo de Euclides para calcular el MCD
    bucle:
        cmp bx, 0    
        je fin       
        mov dx, 0    
        div bx       ; Dividir ax por bx (DX:ax / bx => ax = ax / bx, DX = ax mod bx)
        mov ax, bx   
        mov bx, dx  
        jmp bucle   
    fin:
    mov ax,ax
    call imprimirNumero
    mov dx, offset ponerEspacio
    call ImprimiString
    jmp SALIR_PROGRAMA

    
;RAiz Cuadrada rR
verifica_parametro_r:
    inc si
pasarseEspacio_r:
    cmp byte ptr es:[si], ' '
    jne segundo_parametro_r
    inc si
    jmp pasarseEspacio_r
segundo_parametro_r:  
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10     
    call CONVERTIR_PARAMETRO_NUMERO        
    cmp ax,255
    ja sobrepasa
    mov ax, numero
    mov var_i, 1
ciclo_sqrt:
    mov cx, var_i
    mov ax, cx
    MUL cx             ; ax = cx * cx
    CMP ax, numero
    JA mostrarRaiz
    INC var_i
    JMP ciclo_sqrt

mostrarRaiz:
    mov ax, cx
    call imprimirNumero
    mov dx, offset ponerEspacio
    call ImprimiString
    jmp SALIR_PROGRAMA

;Numero Perfecto nN
verifica_Parametro_n:
    inc si
pasarseEspacio_n:
    cmp byte ptr es:[si], ' '
    jne segundo_parametro_n
    inc si
    jmp pasarseEspacio_n
segundo_parametro_n:  
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10     
    call CONVERTIR_PARAMETRO_NUMERO        
    cmp ax,65335
    ja sobrepasa
        mov ax, numero
    mov auxNum, 0     ; Inicializar auxNum a 0
    mov var_i, 1      ; Inicializar var_i a 1

    cicloDivisores_D:
        mov cx, var_i
        cmp cx, numero
        jge cicloDivisores_D_fin
        mov ax, numero
        xor dx, dx
        div cx
        cmp dx, 0
        jne no_sumarDivisor
        add auxNum, cx
    
    no_sumarDivisor:
        inc var_i
        jmp cicloDivisores_D
    
    cicloDivisores_D_fin:
        mov ax, auxNum
        cmp ax, numero
        je es_perfecto
    
    no_es_perfecto:
        lea dx, msgNoPerfecto
        mov ah, 09h
        int 21h
        jmp SALIR_PROGRAMA
    
    es_perfecto:
        lea dx, msgPerfecto
        mov ah, 09h
        int 21h
         JMP SALIR_PROGRAMA

;Potencia tT
verifica_Parametro_t:
    inc si
pasarseEspacio_t:
    cmp byte ptr es:[si], ' '
    jne segundo_parametro_t
    inc si
    jmp pasarseEspacio_t
segundo_parametro_t:  
    xor ax, ax
    xor bx, bx                                   
    mov bl, byte ptr es:[si]   
    sub bl, '0'   
    cmp bl,9 ;max base 9 max exp 5 || base 3 max expo 9
    ja sobrepasa
    mov base,bx  
    inc si
    pasarseEspacio_t2:
        cmp byte ptr es:[si], ' '
        jne segundo_parametro_t2
        inc si
        jmp pasarseEspacio_t2  
    segundo_parametro_t2:  
        xor bx, bx     
        mov bl, byte ptr es:[si]   
        sub bl, '0'   
        cmp bl,9 ;max base 9 max exp 5 || base 3 max expo 9
        ja sobrepasa
        mov expo,bx
    mov cx,0  
    xor ax,ax   
    xor bx,bx
    mov bx,base   
    mov ax,1
    fnPotencia:
        inc cx
        mul bx
        cmp cx,expo
        jc fnPotencia
        mov ax,ax
        call imprimirNumero       
        mov dx, offset ponerEspacio
        call ImprimiString
    jmp SALIR_PROGRAMA
   

;Fibonacci 
verifica_Parametro_b:
    inc si ;zz b            1..
pasarseEspacio_b:
    cmp byte ptr es:[si], ' ';zz b        10
    jne segundo_parametro_b
    inc si
    jmp pasarseEspacio_b
segundo_parametro_b:  
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10     
    call CONVERTIR_PARAMETRO_NUMERO        
    cmp ax,25
    ja sobrepasa
    mov numero, ax
    mov var_i,1
    mov cx,0
    mov bx,1
    mov ax,0
    fibonacci:
        mov auxNum,ax
        call imprimirNumero       
        mov dx, offset ponerEspacio
        call ImprimiString
        mov ax,var_i
        inc ax
        mov var_i,ax
        cmp ax,numero
        ja SALIR_PROGRAMA
        mov cx,bx
        mov bx,auxNum
        mov ax,0000h
        add ax,cx
        add ax,bx
        jmp fibonacci

;Cubo U u
verifica_Parametro_u:
    inc si
pasarseEspacio_u:
    cmp byte ptr es:[si], ' ';zz u   1
    jne segundo_parametro_u
    inc si
    jmp pasarseEspacio_u
segundo_parametro_u:  
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10     
    call CONVERTIR_PARAMETRO_NUMERO        
    cmp ax,40
    ja sobrepasa
    mov numero, ax
    mov bx,numero
    mul bx
    mul bx
    mov ax, ax
    call imprimirNumero
    jmp SALIR_PROGRAMA

;Primos menores a 
verifica_Parametro_p:; zz p    1000
    inc si
pasarseEspacio_p:
    cmp byte ptr es:[si], ' '
    jne segundo_parametro_p
    inc si
    jmp pasarseEspacio_p
segundo_parametro_p:  
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10     
    call CONVERTIR_PARAMETRO_NUMERO        
    cmp ax,65535
    ja sobrepasa
    mov numero, ax
    call fnPrimosMenores_A
    jmp SALIR_PROGRAMA

fnPrimosMenores_A proc
    mov var_i, 2
    mov ax,numero
    mov auxNum,ax
    recorrer_hasta:

        mov ax, var_i
        mov numero, ax
        call Verificar_Primo 
        cmp estadoPrimo, 1
        je es_primo_vari
        jmp siguiente

        es_primo_vari:
            mov ax, var_i
            call imprimirNumero
            mov dx, offset ponerEspacio
            call ImprimiString

  

        siguiente:
            mov cx,var_i
            inc cx
            cmp cx,auxNum
            ja fnPrimosMenores_A_fin
            mov var_i,cx
            jmp recorrer_hasta
            fnPrimosMenores_A_fin:

fnPrimosMenores_A endp

;Cuadrado c C
verifica_Parametro_c:
    inc si
pasarseEspacio_c:;zz C      1
    cmp byte ptr es:[si], ' '
    jne segundo_parametro_c
    inc si
    jmp pasarseEspacio_c
segundo_parametro_c:  
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10     
    call CONVERTIR_PARAMETRO_NUMERO        
    cmp ax,255
    ja sobrepasa
    mov numero, ax
    call fncuadrado
    jmp SALIR_PROGRAMA

fncuadrado proc
    mov ax,0000h
    mov ax,numero
    mov bx,numero
    mul bx
    mov ax, ax
    call imprimirNumero
    jmp SALIR_PROGRAMA

fncuadrado endp

;Divisores D d
verifica_Parametro_d:; zz D       
    inc si
pasarseEspacio_d:;zz d    8
    cmp byte ptr es:[si], ' '
    jne segundo_parametro_d
    inc si
    jmp pasarseEspacio_d
segundo_parametro_d:  
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10        

    call CONVERTIR_PARAMETRO_NUMERO
    mov numero, ax
    call pro
    jmp SALIR_PROGRAMA

pro proc
    mov cx, numero       ; cx será nuestro contador para el ciclo
    mov bx, 1            ; bx es nuestro divisor que comienza en 1

    ciclo_divisores:     ; Etiqueta del ciclo principal
        mov ax, numero
        cwd              ; Convertir a DX:ax para la división
        div bx           ; ax = ax / bx, DX = ax % bx
        cmp dx, 0        ; Revisar si el residuo es 0
        jne no_es_divisor ; Saltar si no es divisor
            
        ; Si es divisor:
        mov ax, bx
        call imprimirNumero
        mov dx, offset ponerEspacio
        call ImprimiString
        inc contadorDivisores ; Aumentar el contador de divisores
            
    no_es_divisor:
        inc bx            ; Siguiente número para probar
        loop ciclo_divisores
            
    ; Imprimir el total de divisores
    mov dx, offset msgTotalDivisors
    call ImprimiString
    mov ax, contadorDivisores
    call imprimirNumero
    jmp SALIR_PROGRAMA

pro endp

;para la opcion fF factorial
verifica_Parametro_f:
    inc si
pasarseEspacio_f:
    cmp byte ptr es:[si], ' '
    jne segundo_parametro_f
    inc si
    jmp pasarseEspacio_f

segundo_parametro_f:  
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10        
    call CONVERTIR_PARAMETRO_NUMERO
    mov numero, ax
    cmp ax,8
    ja sobrepasa
    jmp fnFactorial

fnFactorial:
    mov cx, numero       
    mov ax, 1       
    cicloFactorial:
        cmp cx, 1         
        jle SalirFactorial        
        mul cx            
        dec cx           
        jmp cicloFactorial

    SalirFactorial:
        mov resultadoFacto, ax 
        lea dx, mensajeFactorial
        mov ah, 09h
        int 21h
        mov ax, resultadoFacto
        call ImprimirResultadoFactorial
        jmp SALIR_PROGRAMA

    ImprimirResultadoFactorial:
        mov bx, 10       
        lea di, buffer    
        add di, 5         
        mov byte ptr [di],'$' 
        dec di            

    convertir_CadenaFactorial:
        xor dx, dx       
        div bx            
        add dl, '0'       
        mov [di], dl      
        dec di            
        test ax, ax       
        jnz convertir_CadenaFactorial  
        inc di             
        lea dx, [di]      
        mov ah, 09h       
        int 21h          
        ret

; Opción de e E EsPrimo?
verifica_Parametro_e:
    inc si
pasarseEspacio_e:
    cmp byte ptr es:[si], ' '
    jne segundo_parametro_e
    inc si
    jmp pasarseEspacio_e

segundo_parametro_e:   
    xor ax, ax
    xor bx, bx                                   
    mov cx, 10        
    call CONVERTIR_PARAMETRO_NUMERO
    mov numero, ax
    call Verificar_Primo
    cmp estadoPrimo,0
    je NOES_PRIMO
    cmp estadoPrimo,1
    je ES_PRIMO
    jmp SALIR_PROGRAMA

verifica_segundo_b:
    inc si
ignorarEspacios_b:
    cmp byte ptr es:[si], ' '
    jne segundo_Parametro_b
    inc si
    jmp ignorarEspacios_b



no_parametros:
    lea dx, nohayParametros
    mov ah, 9
    int 21h
    jmp SALIR_PROGRAMA

invalido_parametro:
    lea dx, msg_invalido
    mov ah, 9
    int 21h
    jmp SALIR_PROGRAMA

sobrepasa:
    LEA DX, msgSobrePasa
    mov AH, 09H          
    INT 21H
    JMP SALIR_PROGRAMA

ES_PRIMO:
    LEA DX, msgPrimo
    mov AH, 09H          
    INT 21H
    JMP SALIR_PROGRAMA

NOES_PRIMO:
    LEA DX, no_msgPrimo
    mov AH, 09H           
    INT 21H    
    jmp SALIR_PROGRAMA
desplegar_menu:
    LEA dx, menu
    mov ah,09h
    int 21h
    jmp SALIR_PROGRAMA
imprimirNumero proc
    pusha
    mov cx, 0
    mov bx, 10        
    
    ; Convertir número a string
    numero_a_string:
        xor dx, dx
        div bx
        add dl, '0'
        push dx
        inc cx
        test ax, ax
        jnz numero_a_string

    ; Imprimir el número
    bucleImprimir:
        pop dx
        mov ah, 02h
        int 21h
        loop bucleImprimir
    
    popa
    ret
imprimirNumero endp

; Procedimiento para imprimir strings
ImprimiString proc
    push ax
    push dx
    mov ah, 09h
    int 21h
    pop dx
    pop ax
    ret
ImprimiString endp

CONVERTIR_PARAMETRO_NUMERO PROC
    cmp byte ptr es:[si], ' '  ; fin de la cadena
    je CONV_FINALIZADA
    cmp byte ptr es:[si], '0'  ; si es menor que '0'
    jb CONV_FINALIZADA
    cmp byte ptr es:[si], '9'  ; si es mayor que '9'
    ja CONV_FINALIZADA
    mov bl, byte ptr es:[si]   
    sub bl, '0'             
    mov dx, ax              
    mov ax, cx              
    mul dx                  
    add ax, bx              
    inc si                    
    jmp CONVERTIR_PARAMETRO_NUMERO
CONV_FINALIZADA:
    mov numero, ax
    ret
CONVERTIR_PARAMETRO_NUMERO ENDP

Verificar_Primo proc
    mov ax, numero        
    cmp ax, 1
    jle NOES_PRIMO_estado      
    mov DX,0
    mov ax, numero
    mov bx, 1     
    mov cx, 1     
    
    cicloPrimo: 
        cmp cx,2
        JA NOES_PRIMO_estado
        mov ax,numero
        CMP bx, ax       
        JE ES_PRIMO_estado       
        mov dx, 0          
        div bx            
        cmp dx, 0          
        je INCREMENTA      
        inc bx
        mov DX,0             
        jmp cicloPrimo          
    
    INCREMENTA:
        INC cx
        INC bx
        mov DX,0
        JMP cicloPrimo
    ES_PRIMO_estado:
        mov estadoPrimo,1
        jmp finVeriprim
    NOES_PRIMO_estado:
         mov estadoPrimo,0
    finVeriprim:
    ret
Verificar_Primo endp

SALIR_PROGRAMA:
    mov AH, 4CH
    INT 21H
END START