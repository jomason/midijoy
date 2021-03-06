			run start

			CH = $2fc
			TRIG0 = $d010
			TRIG1 = $d011
			AUDF1 = $d200
			AUDC1 = $d201
			AUDC2 = $d203
			AUDC3 = $d205
			AUDC4 = $d207

			AUDCTL = $d208
			SKCTL = $d20f

			org $CB

NOTEPTR		.word $9900			; change this to end of notes (unless in BASIC)
PLAYPTR		.word $5000			; change this to beginning of notes (unless in BASIC)
PLAYFLAG	.byte 0
PLAYTIMER	.word 0

			org $0600

			pla					; BASIC routine to pull beginning and length of notes
			cmp #2				; usage: X=USR(1536,PLAYPTR,NOTEPTR) (see above)
			beq pulldata
			tay
			dey
clearstack	pla
			pla
			dey
			bpl clearstack
			rts

pulldata	pla
			sta PLAYPTR+1
			pla
			sta PLAYPTR
			pla 
			sta NOTEPTR+1
			pla 
			sta NOTEPTR

start
			lda PLAYPTR
			sta TEMPPTR
			lda PLAYPTR+1
			sta TEMPPTR+1
			sta PLAYFLAG
			
			lda #3
			sta SKCTL
			lda #0
			sta AUDCTL
			
			ldy #7
cleartimer	sta NOTETIMER,y
			dey
			bpl cleartimer

			ldy #<VBI				; set up VBI
			ldx #>VBI
			lda #6
			jsr $e45c

exit		rts			

VBI			lda PLAYFLAG
			bne dotimer
			jmp exitvbi
dotimer		inc NOTETIMER			; increase timer
			bne donetimer0
			inc NOTETIMER+1
donetimer0	inc NOTETIMER+2
			bne donetimer1
			inc NOTETIMER+3
donetimer1	inc NOTETIMER+4
			bne donetimer2
			inc NOTETIMER+5
donetimer2	inc NOTETIMER+6
			bne startplay
			inc NOTETIMER+7

startplay	lda PLAYPTR+1			; check end of music
			cmp NOTEPTR+1
			bcc doplay
			lda PLAYPTR
			cmp NOTEPTR
			bcs exitplay

doplay		ldy #0
			lda (PLAYPTR),y
			tax						; voice to X
			iny
			lda (PLAYPTR),y
			sta PLAYAUDC			; save AUDC-value
			iny
			lda (PLAYPTR),y
			sta PLAYNOTE			; save note
			iny
			lda (PLAYPTR),y
			sta PLAYTIMER			; save timer low-byte
			iny
			lda (PLAYPTR),y
			sta PLAYTIMER+1			; save timer high-byte

			lda POKEYOffset,x
			tay						; Offset to Y
			lda NOTETIMER+1,y
			cmp PLAYTIMER+1			; Playtimer >= Notetimer (high byte)?
			bcc exitvbi
			lda NOTETIMER,y
			cmp PLAYTIMER			; Playtimer >= Notetimer (low byte)?
			bcc exitvbi
			lda #0					; First reset counters...
			sta PLAYTIMER
			sta PLAYTIMER+1
			sta NOTETIMER,y
			sta NOTETIMER+1,y
			lda PLAYAUDC			; then play note...
			sta AUDC1,y
			lda PLAYNOTE
			sta AUDF1,y
			clc
			lda PLAYPTR
			adc #$05				; increase pointer
			sta PLAYPTR
			bcc startplay
			lda PLAYPTR+1
			adc #0
			sta PLAYPTR+1
			jmp startplay
			
exitplay	ldy #7
			lda #0
clearplayer	sta NOTETIMER,y
			sta AUDC1,y
			dey
			bpl clearplayer
			sta PLAYFLAG

exitvbi		jmp $e45f

NOTE		.byte 0, 0
NOTETIMER	.word 0, 0, 0, 0
PLAYAUDC	.byte 0
PLAYNOTE	.byte 0
TEMPPTR		.word 0

POKEYOffset	.byte 0, 2, 4, 6
