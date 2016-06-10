;Curso de Assembly para PIC Aula 02
;
; MCU:PIC16F84A		Clock: 4MHz
; Autor: Robson Torraca - Wagner Rambo
;

list		p=16f84A		;Microcontrolador utilizado PIC16F84A

; ---Arquivos inclu�dos no projeto---

#include <p16f84a.inc>

; --- FUSE Bits, basedos no arquivo include p16f84a.inc ---
; --- Refer�ncia em CONFIG Options ---
	__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF  
	
; __config_XT_OSC, cristal interno de 4MHz
; __WDT_OFF, "c�o de guarda", Sem dar reset se detectado um evento espec�fico  
; __PWRTE_ON, Liago o tempo que ao iniciar o Mc (72ms) agurada para iniciar o processamento e iniciar os regs
; __CP__OFF, Sem prote��o c�pia de c�digo


; ---Mem�ria de Pagina��o ---
; bcf: b, bit; c, clear; f, file (arquivo, refere ao registrador) ; Pegue determinado bit do reg. Status, o bit RP0 e clear
; bsf: b, bit; set, set; f, file (arquivo, refere ao registrador); Pegue determinado bit do reg. Status, o bit RP0 e set
; Instru��o bcf,bsf com seus argumentos.

#define		bank0		bcf STATUS,RP0 ;Cria minem�nico para banco 0 de mem�ria
#define		bank1		bsf STATUS,RP0 ;Cria minem�nico para banco 1 de mem�ria

; --- Entradas ---
#define		botao1		PORTB,RB0		;Port�o 1 ligado em RB0		 

; --- Sa�das ---

#define		led1		PORTB,RB7		;Led1 ligado em RB7			

; -- RESET VECTOR ----
; Vetor de reset, em 000h, 

; -- Vetor de interrup��o ---
; -- Endere�o do vetor de interup��o, 0004h --- 

; -- ORG ---
; Diretiva de organi��o de mem�ria 

		org		H'0000'				; Origem no endere�o 0000h de mem�ria
		goto 	inicio 				; Desvia do vetor de interrup��o para endere�o
		
; ---Vetor de interrup��o ---
		org		H'0004'				; Todas apontam para este endere�o, entra aqui quando chamada a interrup��o 
		retfie						; Retorna de interrup��o, para o c�digo que a gerou

inicio:

		bank1						; Seleciona Bank1 de mem�ria onde est� TRISB
		; 0 -> Sa�da, output , 1-> Entrada, input
		; Recomendado todos os bits, n�o usados em 1, pois estar� em alta imped�ncia e protegido contra danos 
		; Por isso TRISA e TRISB iniciam em 0 automaticamente, aqui eles estr�o iniciados apenas como exempo
		movlw	H'FF'				; W = B'11111111', todos como entrada
		movwf	TRISA				; Reg. de dire��o do PORTA, TRISA = H'FF' (Todos os bits s�o entrada)	
		movlw	H'7F'				; W = B'01111111', Move uma literal(valor constante) para W(registrador de trabalho)
		movwf	TRISB				; TRISB = H'7F',define apenas o RB7 sa�da	
		bank0						; Retorna para o Bank0, pois � o padr�p reset
		movlw	H'FF'				; W = B'11111111', iniciar PORTB
		movwf   PORTB				; RB7 (Configurado como sa�da), mas iniciado em HIGH, PORTB recebe 10000000, ao valor de W, pois foi definido apenas escrita em RB7 atrav�s de TRISB
		;goto	$					; Vai para esta pr�pria linha, tipo de loop infinito   
		
 loop:
 	
 		; ---Testa de foi precionado---
 		; Bit Test File Skip Clear, testa o bit se for 0 pula uma linha	
 		btfsc	botao1				; Bot�o foi pressionado?
 		goto 	apaga_led1			; N�o, desvia para label apaga
 		bsf		led1				; Bit Set File, liga led1
 		goto 	loop				; Retorna para o loop 
 		
 apaga_led1:
 		bcf		led1				; Bit Clear File, desliga led1
 		goto	loop				; Retorna para loop
		
		end							; Final do programa
		



		

		
		
		











