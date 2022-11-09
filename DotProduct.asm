# Your name:
# Your student id:
# Your email address:

.data
# output messages
initMsgV1: .asciiz "Please enter integers in array V"
initMsgV2: .asciiz "[] one by one:\n"
EnterNumberMsgV: 	.asciiz "V"
EnterNumberMsg2: 	.asciiz "["
EnterNumberMsg3:  .asciiz "]: "
ResultMsg:	.asciiz " Final result of the vector dot product v1 and v2 is : "
# array V1[] has 10 elements, each element is of the size of one word, 32 bits.
V1: .word 0:10
# array V2[] has 10 elements, each element is of the size of one word, 32 bits.
V2: .word 0:10
# size: the number of elements in array A[]
SIZE: .word 10

.text
# .globl main

main:
	la $s0, SIZE
	lw $s0, 0($s0)

	la $s1, V1
	add $a1, $s1, $zero	# $a1 is the vector's address
	add $a2, $s0, $zero	# $a2 is the vector's size
	li $a3, 1		# $a3 is the order of the two vectors
	jal input_array_function		# input V1
	
	la $s1, V2
	add $a1, $s1, $zero	# $a1 is the vector's address
	add $a2, $s0, $zero	# $a2 is the vector's size
	li $a3, 2		# $a3 is the order of the two vectors
	jal input_array_function		# input V2
	
	la $a0, V1
	la $a1, V2
	la $a2, SIZE
	lw $a2, 0($a2)
	jal DotProduct
	move $s0, $v0
	print_result:
	la $a0, ResultMsg
	li $v0, 4
	syscall
	add $a0, $s0, $zero
	li $v0, 1
	syscall
	exit:
	li $v0, 10
	syscall


input_array_function:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	#cout << "Please enter integers in array v"<<order<<"[] one by one: " <<endl;
	print_msg:
	la $a0, initMsgV1
	li $v0, 4
	syscall
	move $a0, $a3
	li $v0, 1
	syscall
	la $a0, initMsgV2
	li $v0, 4
	syscall
			
	li $t0, 0
	input_array:
	beq $t0, $a2, exit_input
	# cout << "v" << order << "["<<i<<"]:"
	la $a0, EnterNumberMsgV
	li $v0, 4
	syscall
	move $a0, $a3
	li $v0, 1
	syscall
	la $a0, EnterNumberMsg2
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	la $a0, EnterNumberMsg3
	li $v0, 4
	syscall
	# read user input in $v0
	li $v0, 5
	syscall
	sll $t1,$t0,2
	add $t1,$t1,$a1 # $t1 = i*4 + base of V in $a1, addr of V[i]
	sw $v0, 0($t1)  # V[i] = $v0
	addi $t0,$t0,1
	j input_array
	exit_input:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra 	
			
	
					
# This function does the same thing as the function DotProduct() in the C++ program
# arguments are in $a0, $a1 and $a2
# $a0: base address of array V1[]
# $a1: base address of array V2[]
# $a2: SIZE of the two arrays
# Output: 
# The dot product result should be stored in $v0. 
# Remeber to preserve registers as needed																			
DotProduct:			
	#push - DotProduct:
	addi $sp, $sp, -4	#move the stack pointer down
	sw $ra, 0($sp)		#store line 44 into the stack
	li $v0, 0		#int $v0 = 0;
	#end push -DotProduct

	li $t0, 0		#int $t0 = i = 0 (our iterator)	
	for_loop_dotProduct:
	beq $t0, $a2, exit_for_loop_dotProduct	#if i == size of array, exit loop
	
	addi $t1, $a0, 0	#temporarily Save $a0 to $t1
	addi $t2, $a1, 0	#temporarily save $a1 to $t2
	addi $t5, $v0, 0	#temporarily Save our return value ($v0) into $t5
	addi $t6, $t0, 0	#temporarily Save our i (iterator) ($t0) into $t6
	
	sll $t3, $t0, 2		#multiply i by 4 and save it to $t3
	add $a0, $t1, $t3	#get the address of V1[i] save it to $a0
	add $a1, $t2, $t3	#get the address of V2[i] save it to $a1
	
	lw $a0, 0($a0)		#store the VALUE of V1[i] into $a0
	lw $a1, 0($a1)		#store the VALUE of V2[i] into $a1
	jal Multiply		#will store the result into $v0, overwriting our previous $v0 so...
	
	addi $t0, $t6, 0	# restore our i (iterator) ($t6) back into $t0
	add $v0, $v0, $t5 	# add result ($t5) and return of Multiply() ($v0) store into $v0
	addi $a0, $t1, 0	#restore saved value of $a0
	addi $a1, $t2, 0	# restore saved values of $a1
	
	addi $t0, $t0, 1	# i++
	j for_loop_dotProduct	# loop
	exit_for_loop_dotProduct:
	
	#pop - DotProduct
	lw $ra, 0($sp)	#restore the last added address in the stack to $ra, (4)
	addi $sp, $sp, 4 # move the stack pointer up
	#end_pop	
	jr $ra		


# This function does the same thing as the function Multiply() in the C++ program
# arguments are in $a0 and $a1 
# $a0: non-negative integer a	
# $a1: non-negative integer b
# Output: 
# The multiplication result should be stored in $v0. 
# Remeber to preserve registers as needed	
Multiply:

	#push - Multiply:
	addi $sp, $sp, -4	#move the stack pointer down
	sw $ra, 0($sp)		#store line x into the stack
	li $v0, 0		#int $v0 = 0;
	#end_push - Multiply
	
	li $t0, 0		#int $t0 = i = 0 (our iterator)
	for_loop_Multiply:
	beq $t0, $a1, exit_for_loop_Multiply	#if i == b ($a1), exit loop
	add $v0, $v0, $a0 	# result = result ($v0) + a ($a0)

	addi $t0, $t0, 1	# i++
	j for_loop_Multiply	# loop
	
	exit_for_loop_Multiply:
	
	#pop - Multiply
	lw $ra, 0($sp)	#restore the last added address in the stack to $ra, 
	addi $sp, $sp, 4 # move the stack pointer up
	#end_pop
	jr $ra #will jump to line $ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
