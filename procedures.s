




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
	addi $sp, $sp, -4	#move the stack pointer down
	sw $ra, 0($sp) 	#store address of next instruction relative to callee (1) 
			# in this case will store line 15.
	#end_push
	
	addi $t0, $zero, 4
	jal proc
	
	#pop
	lw $ra, 0($sp)	#restore the last added address in the stack to $ra, (4)
			#will restore line 15
	addi $sp, $sp, 4 # move the stack pointer up
	#end_pop
	
	jr $ra		# will jump to line 15
proc:

	#push
	addi $sp, $sp, -4 	# move stack pointer down 
	sw $ra, 0($sp)	# store address of next instruction relatie to callee (2)
			# in this case will store line 29.
	#end_push
	
	addi $t0, $zero, 5
	

	#pop
	lw $ra, 0($sp)	#restore the last added address in the stack to $ra, (3)
			# will restore line 29.
	addi $sp, $sp, 4 # move the stack pointer up
	#end_pop
	
	jr $ra #will jump to line 29
	
	
# can be summarized to:
# jump, store callee -> next address
# jump, store callee2 -> next address
# pop, collect callee2 -> next address and jump to it
# pop, collect callee1 -> next address and jump to it.