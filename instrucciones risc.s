;; PIC16F887 ? Encendido intercalado de LEDs Rojo y Azul
; RD0 ? LED Rojo
; RD1 ? LED Azul

; CONFIGURACIÓN
    CONFIG  FOSC = INTRC_CLKOUT   
    CONFIG  WDTE = OFF            
    CONFIG  PWRTE = OFF           
    CONFIG  MCLRE = ON            
    CONFIG  CP = OFF              
    CONFIG  CPD = OFF             
    CONFIG  BOREN = OFF           
    CONFIG  IESO = OFF            
    CONFIG  FCMEN = OFF           
    CONFIG  LVP = OFF             
    CONFIG  BOR4V = BOR40V        
    CONFIG  WRT = OFF             

#include <xc.inc> 

    PSECT   MainCode,global,class=CODE,delta=2

MAIN:
    ;--- Configurar reloj interno a 8 MHz ---
    BANKSEL OSCCON
    movlw 0x70       ; IRCF = 111 ? 8 MHz
    movwf OSCCON

    ;--- Deshabilitar entradas analógicas ---
    BANKSEL ANSEL
    clrf ANSEL       
    clrf ANSELH      

    ;--- Configurar RD0 y RD1 como salidas ---
    BANKSEL TRISD
    bcf TRISD,0      ; RD0 salida (Rojo)
    bcf TRISD,1      ; RD1 salida (Azul)

    ;--- Apagar LEDs al inicio ---
    BANKSEL PORTD
    clrf PORTD       

;-------------------------
; Bucle principal
;-------------------------
MainLoop:
    bsf PORTD,0      ; Rojo ON
    bcf PORTD,1      ; Azul OFF
    call DELAY

    bsf PORTD,1      ; Azul ON
    bcf PORTD,0      ; Rojo OFF
    call DELAY

    goto MainLoop

;-------------------------
; Subrutina DELAY (~500 ms)
;-------------------------
DELAY:
    BANKSEL 0           ; Asegura estar en banco 0 para usar RAM general
    movlw 0x0A          ; Cambia este valor para ajustar el retardo
    movwf TEMP3

DelayLoop1:
    movlw 0xFF
    movwf TEMP1
DelayLoop2:
    movlw 0xFF
    movwf TEMP2
DelayLoop3:
    decfsz TEMP2, f
    goto DelayLoop3
    decfsz TEMP1, f
    goto DelayLoop2
    decfsz TEMP3, f
    goto DelayLoop1
    return

;-------------------------
; Definición de variables
;-------------------------
TEMP1   equ 0x20
TEMP2   equ 0x21
TEMP3   equ 0x22

    END MAIN
