;Curso de Assembly para PIC Aula 02
;
; MCU:PIC16F84A		Clock: 4MHz
; Autor: Robson Torraca - Wagner Rambo
;

list		p=16f84A		;Microcontrolador utilizado PIC16F84A

; ---Arquivos incluídos no projeto---

#include <p16f84a.inc>

; --- FUSE Bits, basedos no arquivo include p16f84a.inc ---
; --- Referência em CONFIG Options ---
	__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF  
	
; __config_XT_OSC, cristal interno de 4MHz
; __WDT_OFF, "cão de guarda", Sem dar reset se detectado um evento específico  
; __PWRTE_ON, Liago o tempo que ao iniciar o Mc (72ms) agurada para iniciar o processamento e iniciar os regs
; __CP__OFF, Sem proteção cópia de código


; ---Memória de Paginação ---
; bcf: b, bit; c, clear; f, file (arquivo, refere ao registrador) ; Pegue determinado bit do reg. Status, o bit RP0 e clear
; bsf: b, bit; set, set; f, file (arquivo, refere ao registrador); Pegue determinado bit do reg. Status, o bit RP0 e set
; Instrução bcf,bsf com seus argumentos.

#define		bank0		bcf STATUS,RP0 ;Cria minemônico para banco 0 de memória
#define		bank1		bsf STATUS,RP0 ;Cria minemônico para banco 1 de memória

; --- Entradas ---
#define		botao1		PORTB,RB0		;Portão 1 ligado em RB0		 

; --- Saídas ---

#define		led1		PORTB,RB7		;Led1 ligado em RB7			

; -- RESET VECTOR ----
; Vetor de reset, em 000h, 

; -- Vetor de interrupção ---
; -- Endereço do vetor de interupção, 0004h --- 

; -- ORG ---
; Diretiva de organição de memória 

		org		H'0000'				; Origem no endereço 0000h de memória
		goto 	inicio 				; Desvia do vetor de interrupção para endereço
		
; ---Vetor de interrupção ---
		org		H'0004'				; Todas apontam para este endereço, entra aqui quando chamada a interrupção 
		retfie						; Retorna de interrupção, para o código que a gerou

inicio:

		bank1						; Seleciona Bank1 de memória onde está TRISB
		; 0 -> Saída, output , 1-> Entrada, input
		; Recomendado todos os bits, não usados em 1, pois estará em alta impedância e protegido contra danos 
		; Por isso TRISA e TRISB iniciam em 0 automaticamente, aqui eles estrão iniciados apenas como exempo
		movlw	H'FF'				; W = B'11111111', todos como entrada
		movwf	TRISA				; Reg. de direção do PORTA, TRISA = H'FF' (Todos os bits são entrada)	
		movlw	H'7F'				; W = B'01111111', Move uma literal(valor constante) para W(registrador de trabalho)
		movwf	TRISB				; TRISB = H'7F',define apenas o RB7 saída	
		bank0						; Retorna para o Bank0, pois é o padrãp reset
		movlw	H'FF'				; W = B'11111111', iniciar PORTB
		movwf   PORTB				; RB7 (Configurado como saída), mas iniciado em HIGH, PORTB recebe 10000000, ao valor de W, pois foi definido apenas escrita em RB7 através de TRISB
		;goto	$					; Vai para esta própria linha, tipo de loop infinito   
		
 loop:
 	
 		; ---Testa de foi precionado---
 		; Bit Test File Skip Clear, testa o bit se for 0 pula uma linha	
 		btfsc	botao1				; Botão foi pressionado?
 		goto 	apaga_led1			; Não, desvia para label apaga
 		bsf		led1				; Bit Set File, liga led1
 		goto 	loop				; Retorna para o loop 
 		
 apaga_led1:
 		bcf		led1				; Bit Clear File, desliga led1
 		goto	loop				; Retorna para loop
		
		end							; Final do programa
		



		

		
		
		











