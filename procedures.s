




.text
.globl _main

_main:

	addi $t0, $zero, 0
	addi $t0, $zero, 1
	addi $t0, $zero, 2
	jal max
	addi $t0, $zero, 3
max: 	
	#push
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	#end_push
	
	addi $t0, $zero, 4
	jal proc
	
	#pop
	lw $ra, 0($sp)	
	addi $sp, $sp, 4
	#end_pop
	
	jr $ra
proc:
	#push
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	#end_push
	
	addi $t0, $zero, 5
	
	#pop
	lw $ra, 0($sp)	
	addi $sp, $sp, 4
	#end_pop
	
	jr $ra
	