.data
pl:	.word 0 	// conterra' l'indirizzo della lista (0 sarebbe null) 

	.text
	.global main
	.global ins
	.global cerca

@
@	codice che inizializza la lista con valori dummy
@

main:	push {r4-r7,lr}
	ldr r4, =pl	@indirizzo del puntatore a inizio lista
	
	@ inserzione di un elemento
	mov r0, r4 	@ primo parametro, indirizzo del puntatore a inizio lista
	mov r1, #3	@ valore da inserire
	bl ins
	mov r0, r4
	mov r1, #2
	bl ins	 //insert prende l'indirizzo iniziale e l'elemento da aggiungere, scorre la liste e attacca in fondo l'elemento
	mov r0, r4  
	mov r1, #1
	bl ins
			@ qui ho lista di tre elementi [3] -> [2] -> [1] -> NULL

	ldr r0, [r4]	@ primo parametro:   indirizzo del primo elemento della lista
	mov r1, #3	@ secondo parametro: valore da cercare
	bl cerca	@ cerca  e restituisci come return value il booleano (gia' in r0)

	pop {r4-r7,lr}	@ rispristina i registri utilizzati
	mov pc, lr	@ main: return(r0)


@@
@@ ricerca di un valore in una lista
@@ restituisce vero (1) o falso (1)
@@ 
cerca: 	cmp r0, #0	//se trovo il null devo restituire falso
	beq falso	@ se la lista è vuota, non c'è
loop:	ldr r2, [r0, #0]@ altrimenti guarda se è l'elemento corrente
	cmp r2, r1
	beq vero	@ se è, restituisci vero
	ldr r0, [r0, #4]@ altrimenti carica -> next
	b cerca		@ e ricomincia

vero:	mov r0, #1	@ restituisci vero
	mov pc, lr
falso:  mov r0,#0	@ restituisci falso
	mov pc,lr
@
@	inserimento di un valore nella lista, utilizza malloc per allocare memoria
@
ins:			@ r0 è l'indirizzo del puntatore alla lista
			@ r1 è il valore da inserire
	push {lr}	@ salvo indirizzo di ritorno
	ldr r2, [r0]	@ puntatore al primo elemento //[r0] è il valore del puntatore al primo elemento
	cmp r2, #0 	@ controlla se fosse NULL
	beq vuota	@ se la loadreg ha caricato 0 la lista è ancora vuota
			@ se la lista non è vuota, scorro fino alla fine
scorri:	ldr r3, [r2,#4] @ non vuota, carico il next
	cmp r3, #0	@ se non è NULL, vado avanti
	movne r2,r3	//quello che ho caricato lo metto in r2 e riscorro
	bne scorri	@ arriva all'ultimo elemento, il cui indirizzo è in r2
			@ a questo punto posso allocare memoria e metterla in fondo 
	//a questo punto sono arrivato in fondo alla lista
insend:	push {r1,r2}	@ indirizzo ultimo elemento, valore da inserire
	mov r0, #8	@ alloca due parole
	bl malloc
	pop {r1,r2}	@ indirizzo ultimo elemento e valore da inserire
	str r0, [r2,#4] @ collega elemento allocato
	str r1, [r0]	@ memorizza valore
	mov r1, #0
	str r1, [r0,#4]	@ termina con puntatore NULL
	b ret		@ si poteva copiare pop e mov qui, ma così è più chiaro... 
			@ qui arrivo la prima volta, con lista vuota
vuota:	push {r0, r1}	@ ind punt, val
	mov r0, #8 	@ due parole, una per il valore una per il next
	bl malloc	@restituisce in r0 il puntatore alla memoria
	pop {r2, r3}	@ ind pun, val
	str  r0, [r2]	@ nuovo puntatore a inizio lista ... 
	str r3, [r0]	@ valore
	mov r1, #0	//scrivo null all'ultima posizione della lista
	str r1, [r0,#4]	@ next = NULL

ret: 	pop {pc}   //riprendo dallo stack il lr mettendolo in pc e quindi torno all'esecuzione normale del programma all'istruzione successiva
