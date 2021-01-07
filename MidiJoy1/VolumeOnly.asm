			AUDCTL =    $D208
			AUDF1  =    $D200
			AUDC1  =    $D201
			SKCTL  =    $D20F

			org $b0

TEMPO		.byte 1
MSC			.byte 0

			org $2000
			
			LDA  #0
			STA  AUDCTL
			LDA  #3
			STA  SKCTL
			LDX  #0

			LDA  #0
			STA  $D40E  ; kill vbi's
			STA  $D20E  ; kill irq's
			STA  $D400  ; kill dma

L00			LDA  #15
			STA  MSC

			LDA  VTAB,X
			AND  #%00001111
			STA  AUDC1
			LDA  VTAB,X
			ROR
			ROR
			ROR
			ROR
			STA  AUDC1
L0  		LDY  TEMPO
L1			DEY
			BNE  L1

; dec most sig ctr
			DEC  MSC
			BNE  L0

; new note

			INX
			CPX  NC
			BNE  L00

; wrap note pointer
			LDX #0
			BEQ L00

NC		   .BYTE 255;  note count

; table of volumes to be played In succession

VTAB
			.BYTE 135, 102, 102, 103, 119, 102, 119, 119, 136, 137, 154, 169, 135, 102, 119, 119, 135, 103, 136, 137, 152, 136, 101, 85, 68, 104, 137, 154, 187, 153, 152, 120, 134, 68, 85, 102, 120, 152, 153, 152, 137, 134, 103, 118, 86, 137, 153, 170, 134, 118, 84, 104, 152, 137, 137, 121, 169, 119, 119, 85, 103, 118, 122, 186, 170, 134, 103, 134, 85, 103, 120, 171, 169, 152, 118, 120, 98, 19, 87, 138, 220, 171, 202, 135, 153, 100, 52, 85, 104, 102, 139, 185, 136, 168, 99, 51, 85, 172, 204, 203, 150, 121, 151, 83, 52, 71, 152, 121, 168, 102, 188, 168, 82, 19, 110, 253, 154, 134, 87, 185, 135, 84, 69, 138, 186, 187, 148, 69, 101, 51, 35, 38, 189, 222, 237, 150, 104, 119, 117, 51, 88, 204, 187, 168, 86, 138, 135, 82, 0, 56, 204, 220, 166, 89, 187, 200, 83, 52, 88, 136, 155, 134, 88, 151, 84, 67, 56, 223, 255, 233, 67, 85, 102, 101, 68, 89, 205, 221, 216, 67, 103, 152, 83, 0, 57, 204, 238, 182, 104, 154, 153, 83, 18, 106, 189, 235, 101, 69, 137, 134, 65, 19, 155, 206, 251, 84, 70, 155, 168, 98, 37, 138, 191, 217, 101, 104, 135, 83, 32, 23, 154, 238, 184, 101, 138, 185, 116, 35, 121, 190, 236, 148, 49, 52, 52, 68, 55, 189, 255, 252, 134, 87, 119, 84, 32, 4, 136, 206, 220, 168, 156, 201, 83, 0, 21, 139, 220, 167, 85, 138, 185, 117, 35, 104, 173, 220, 150, 52, 87, 119, 100, 55, 170, 205, 201, 83, 69, 138, 186, 98, 35, 89, 223, 253, 134, 103, 116, 49, 0, 4, 140, 255, 253, 152, 121, 153, 100, 19, 87, 172, 204, 150, 84, 85, 101, 84, 103, 137, 188, 236, 151, 120, 153, 169, 82, 34, 53, 139, 220, 168, 137, 119, 101, 33, 54, 139, 221, 184, 84, 104, 137, 152, 102, 121, 188, 220, 133, 50, 69, 102, 100, 70, 121, 189, 203, 152, 120, 120, 135, 83, 35, 69, 158, 254, 202, 169, 118, 82, 0, 1, 89, 190, 219, 134, 137, 188, 202, 117, 87, 138, 186, 133, 69, 85, 102, 69, 70, 105, 173, 220, 167, 102, 119, 136, 99, 35, 87, 156, 220, 186, 152, 86, 101, 50, 53, 139, 238, 234, 101, 85, 103, 136, 85, 102, 123, 205, 185, 103, 102, 118, 99, 33, 37, 155, 203, 169, 137, 154, 204, 166, 50, 20, 123, 220, 153, 152, 120, 118, 66, 35, 89, 188, 202, 119, 102, 121, 186, 134, 102, 137, 187, 150, 101, 86, 103, 101, 68, 70, 156, 223, 201, 135, 103, 137, 133, 49, 36, 123, 238, 204, 185, 135, 100, 49, 17, 88, 189, 218, 135, 119, 138, 170, 135, 118, 103, 155, 150, 103, 103, 119, 119, 84, 69, 120, 171, 152, 152, 152, 153, 168, 117, 85, 106, 203, 169, 135, 135, 101, 67, 18, 71, 190, 235, 152, 101, 103, 154, 135, 102, 104, 188, 152, 119, 119, 118, 84, 51, 69, 104, 204, 220, 170, 169, 137, 134, 50, 18, 72, 171, 204, 186, 151, 102, 101, 51, 70, 139, 187, 151, 85
; this table contains the duration of each entry above

DTAB
			.BYTE 1,1,1,2,2,2,3,6
			.BYTE 3,2,2,2,1,1,1
			.BYTE 1,1,2,2,2,3,6
			.BYTE 3,2,2,2,1,1			