	.data
fmt:	.ascii "%d + %d = %d \n"

	.text
	.global main

main:	ldr r0, =fmt
	mov r1, #2
	mov r2, #3
	add r3, r1, r2

	bl printf

	mov r7, #1
	svc 0
