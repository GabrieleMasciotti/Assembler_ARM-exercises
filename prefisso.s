	.data
x:	.word 1,2,3,4   //indirizzo di cui va calcolato il prefisso
n:	.word 4         //lunghezza del vettore

fmt:	.ascii "%d, %d, %d, %d. \n"

	.text
	.global main


main:	ldr r0, =n
	ldr r0, [r0]    //caricamento di n in r0
	ldr r1, =x      //indirizzo del vettore, modifica in place

	//codice che calcola il prefisso

	mov r2, r1
	mov r4, r1
	lsl r0, r0, #2
	add r4, r4, r0
	mov r5, #0
	
loop:	ldr r3, [r2]
	add r5, r5, r3
	str r5, [r2], #4
	cmp r2, r4
	ble loop

	ldr r0, =fmt
	ldr r2, [r1,#4]
	ldr r3, [r1,#8]
	ldr r4, [r1,#12]
	push {r4}
	ldr r1, [r1]

	bl printf


	
	mov r7, #1      //exit
	svc 0

