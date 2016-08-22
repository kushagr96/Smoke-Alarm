#make_bin#

#LOAD_SEGMENT=FFFFh#
#LOAD_OFFSET=0000h#

#CS=0000h#
#IP=0000h#

#DS=0000h#
#ES=0000h#

#SS=0000h#
#SP=FFFEh#

#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h#

; add your code here
         jmp     t_isr0
         db     509 dup(0)

;IVT entry for 80H
         
         dw     t_isr0
         dw     0000
		 db 	508 dup(0)
;main program
          
st1:      cli 
; intialize ds, es,ss to start of RAM
          mov       ax,0200h
          mov       ds,ax
          mov       es,ax
          mov       ss,ax
          mov       sp,0FFFEH

;8255
porta	equ		00h
portb	equ		02h
portc	equ		04h
creg	equ		06h

;8253
cnt0	equ		08h
cnt1	equ		0ah
cnt2	equ		0ch
cr		equ		0eh


		;initialize 8255
		mov al,10010000b
		out creg,al
		
		;initialize 8253
		
		mov al,00010100b
		out cr,al
		
		mov al,09h
		out cnt0,al
				
		;initialize 8259
		mov al,13h
		out 10h,al
		
		mov al,80h
		out 12h,al
		
		mov al,03h
		out 12h,al
		
		mov al,0feh
		out 12h,al
		
		sti
		
;loop till isr
xa:
jmp       xa
		; code for isr0
t_isr0:		
		MOV BX,3
X6:		mov cx,0fffFh
x5:		
		PUSH CX
		POP CX
		dec cx
		jnz x5
		DEC BX
		JNE X6

		
		in al,porta
		and al,111b
		cmp al,001b
		jz x1
		cmp al,010b
		jz x1
		cmp al,100b
		jz x1
		
		;open doors
		mov al,05h
		out portc,al
		
		;poll till the smoke is removed
x2:		in al,porta
		and al,111b
		jnz x2
		mov al,0
		out portc,al
		IRET
		
		;malfunc
x1:		mov al,02h 
		out portc,al;

		iret
		