    PROCESSOR 16F887
    #include <xc.inc>

; CONFIGURACIÓN
  CONFIG  FOSC = INTRC_NOCLKOUT
  CONFIG  WDTE = OFF
  CONFIG  PWRTE = OFF
  CONFIG  MCLRE = ON
  CONFIG  CP = OFF
  CONFIG  CPD = OFF
  CONFIG  BOREN = ON
  CONFIG  IESO = OFF
  CONFIG  FCMEN = OFF
  CONFIG  LVP = OFF
  CONFIG  BOR4V = BOR40V
  CONFIG  WRT = OFF

; VECTOR DE RESET
    PSECT resetVect,class=CODE,delta=2
    goto Start

; VARIABLES
    PSECT udata_shr
_blinkCount:   ds 1
_secCount:     ds 1
_d1:           ds 1
_d2:           ds 1
_d3:           ds 1

; CÓDIGO PRINCIPAL
    PSECT code,class=CODE,delta=2

Start:
    banksel ANSEL
    clrf ANSEL
    clrf ANSELH

    banksel TRISA
    clrf TRISA
    clrf TRISB
    clrf TRISC
    clrf TRISD

    banksel PORTA
    clrf PORTA
    clrf PORTB
    clrf PORTC
    clrf PORTD

MainLoop:
    call NS_Verde
    call NS_Amarillo
    call EO_Verde
    call EO_Amarillo
    goto MainLoop

; ================================
; NORTE?SUR VERDE, ESTE?OESTE ROJO
; ================================
NS_Verde:
    bsf PORTA,2      ; RA2 verde
    bsf PORTD,0      ; RD0 verde
    bsf PORTB,0      ; RB0 rojo
    bsf PORTC,0      ; RC0 rojo
    call Delay_10s
    bcf PORTA,2
    bcf PORTD,0
    return

; ================================
; NORTE?SUR AMARILLO, ESTE?OESTE ROJO
; ================================
NS_Amarillo:
    call Blink_RA1   ; RA1 amarillo
    call Blink_RD1   ; RD1 amarillo
    bcf PORTB,0
    bcf PORTC,0
    bsf PORTA,0      ; RA0 rojo
    bsf PORTD,2      ; RD2 rojo
    return

; ================================
; ESTE?OESTE VERDE, NORTE?SUR ROJO
; ================================
EO_Verde:
    bsf PORTB,2      ; RB2 verde
    bsf PORTC,2      ; RC2 verde
    call Delay_10s
    bcf PORTB,2
    bcf PORTC,2
    return

; ================================
; ESTE?OESTE AMARILLO, NORTE?SUR ROJO
; ================================
EO_Amarillo:
    call Blink_RB1   ; RB1 amarillo
    call Blink_RC1   ; RC1 amarillo
    bcf PORTA,0
    bcf PORTD,2
    bsf PORTB,0      ; RB0 rojo
    bsf PORTC,0      ; RC0 rojo
    return

; ================================
; PARPADEO AMARILLO
; ================================
Blink_RA1:
    movlw 6
    movwf _blinkCount
BY_A:
    bsf PORTA,1
    call Delay_250ms
    bcf PORTA,1
    call Delay_250ms
    decfsz _blinkCount,f
    goto BY_A
    return

Blink_RD1:
    movlw 6
    movwf _blinkCount
BY_D:
    bsf PORTD,1
    call Delay_250ms
    bcf PORTD,1
    call Delay_250ms
    decfsz _blinkCount,f
    goto BY_D
    return

Blink_RB1:
    movlw 6
    movwf _blinkCount
BY_B:
    bsf PORTB,1
    call Delay_250ms
    bcf PORTB,1
    call Delay_250ms
    decfsz _blinkCount,f
    goto BY_B
    return

Blink_RC1:
    movlw 6
    movwf _blinkCount
BY_C:
    bsf PORTC,1
    call Delay_250ms
    bcf PORTC,1
    call Delay_250ms
    decfsz _blinkCount,f
    goto BY_C
    return

; ================================
; RUTINAS DE TIEMPO
; ================================
Delay_10s:
    movlw 10
    movwf _secCount
D10:
    call Delay_1s
    decfsz _secCount,f
    goto D10
    return

Delay_1s:
    call Delay_250ms
    call Delay_250ms
    call Delay_250ms
    call Delay_250ms
    return

Delay_250ms:
    movlw 0x64
    movwf _d1
D25_A:
    movlw 0xFF
    movwf _d2
D25_B:
    movlw 0x05
    movwf _d3
D25_C:
    decfsz _d3,f
    goto D25_C
    decfsz _d2,f
    goto D25_B
    decfsz _d1,f
    goto D25_A
    return

    END
