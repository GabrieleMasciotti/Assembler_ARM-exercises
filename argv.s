	.text
	.global main

main:	ldr r0, [r1, #4]   //indirizzo di argv[1] in r0 (primo elemento passato al main)
	bl atoi
	mov r7, #1
	svc 0


atoi:	mov r1, #0
	mov r3, #10
loop:	ldrb r2, [r0], #1   //legge il primo carattere del numero passato al main (primo byte) e incrementa la base
	cmp r2, #0
	moveq r0, r1   //controlla se null, cioè se abbiamo raggiunto la fine della stringa passata al main (che finisce con \0) e se si ritorna all'istruzione successiva alla funzione
	moveq PC, LR
	mul r1, r1, r3    //moltiplico il valore precedente per 10
	sub r2, r2, #48
	add r1, r1, r2
	b loop
