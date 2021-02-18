	.data
res:	.word 0,1
	.text
	.global main

main:	ldr r1, =res
	str r0, [r1]
	mov r0, #1
	mov r2, #8
	mov r7, #4
	svc 0
	mov r7, #1
	svc 0
	
