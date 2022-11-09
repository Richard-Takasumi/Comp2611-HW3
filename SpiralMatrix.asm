# Your name:
# Your student id:
# Your email address:

.data
# output messages
Msg1: .asciiz "Please enter an integer (1-10):\n"
Msg2: .asciiz "The spiral matrix is:\n"
# array spiral[] has at most 100 elements, each element is of the size of one word, 32 bits.
spiral: .word 0:100
space: .asciiz "\t"
newline: .asciiz "\n"

.text
# .globl main

main:
	la $s1,spiral       #$s1 base address of array spiral[]

	# cout<<"Please enter an interger(1-10):"<<endl;
	la $a0, Msg1
	li $v0, 4
	syscall
		
	# read n
	li $v0, 5
	syscall
	move $s2,$v0

	# calculate the spiral order of matrix
	move $a0,$s1	# $a0 -> Address of SpiralMatrix
	move $a1,$s2	# $a1 = n
	jal SpiralMatrix
        
	# cout<<"The spiral matrix is:"<<endl;
	la $a0, Msg2
	addi $v0, $zero, 4
	syscall    
	
	# print elements in spiral order
	move $a1,$s1
	move $a2,$s2
	jal print
        
	# return
	exit:
	addi $v0, $zero, 10 
	syscall

# This functions generates the spiral matrix
# The results are stored in spiral[]
# arguments are in $a0 and $a1
# $a0: base address of the matrix spiral[]
# $a1: number of rows/columns of spiral[]
# preserve registers as needed
SpiralMatrix:
#TODO below	
	sw $s0, -4($sp)
	sw $s1, -8($sp)
	sw $s2, -12($sp)
	sw $s3, -16($sp)
	sw $s4, -20($sp)
	sw $s5, -24($sp)
	sw $s6, -28($sp)
	sw $ra, -32($sp)
	sub $sp, $sp, 32
	
	li $s0,  0 		# row1    ($s0) = 0
	addi $s1, $a1, -1 	# row2    ($s1) = n ($a1) - 1
	addi $s2, $a1, -1 	# column1 ($s2) = n ($a1) - 1
	li $s3, 0		# column2 ($s3) = 0
	li $s4, 1	#	aij value ($s4) = 1
	li $s5, 0		# i = 0	  ($s5) = 0 
	li $s6, 0		# j = 0   ($s6) = 0

	
	while:
		sle $t0, $s0, $s1 #sets $t0 to 1 if row-1 <= row-2
		sge $t1, $s2, $s3 #sets $t1 to 1 if col-1 >= col-2
		and $t2, $t0, $t1 # if t0 and t1 == 1; set t2 = 1; otherwise set t2 = 0
		beqz $t2, exit_while	#if t2 is 0, exit the loop
		
		addi $s5, $s0, 0 # i  = row-1
		addi $s6, $s2, 0 # j = col-1
		for_loop_1:
			blt $s6, $s3, exit_for_loop_1	# if s6 (j) < s3 (column-2), exit for_loop
			mul $t7, $a1, $s5 	# t7 = i * n 
			add $t7, $t7, $s6	# s7 (index value)  = i * n + j 
			sll $t7, $t7, 2		# t7 = aij value * 4 (for address indexing)
			add $t7, $t7, $a0	# t7 = &spiral[i * n + j]
			sw $s4, 0($t7)		# spiral[i * n + j] = aijValue;
			addi $s4, $s4, 1	# aijValue++
			addi $s6, $s6, -1		# j--
		j for_loop_1
		exit_for_loop_1:
		
		
		addi $s5, $s0, 1 # i  = row-1 + 1
		addi $s6, $s3, 0 # j = col-2
		for_loop_2:
			bgt $s5, $s1, exit_for_loop_2	# if s5 (i) > s1 (row-2), exit for_loop
			mul $t7, $a1, $s5 	# t7 = i * n 
			add $t7, $t7, $s6	# s7 (index value)  = i * n + j 
			sll $t7, $t7, 2		# t7 = aij value * 4 (for address indexing)
			add $t7, $t7, $a0	# t7 = &spiral[i * n + j]
			sw $s4, 0($t7)		# spiral[i * n + j] = aijValue;
			addi $s4, $s4, 1	# aijValue++
			addi $s5, $s5, 1		# i++
		j for_loop_2
		exit_for_loop_2:
	
	
		addi $s5, $s1, 0 # i  = row-2
		addi $s6, $s3, 1 # j = col-2 + 1
		for_loop_3:
			bge $s6, $s2, exit_for_loop_3	# if s6 (j) >= s2 (col-1), exit for_loop
			mul $t7, $a1, $s5 	# t7 = i * n 
			add $t7, $t7, $s6	# s7 (index value)  = i * n + j 
			sll $t7, $t7, 2		# t7 = aij value * 4 (for address indexing)
			add $t7, $t7, $a0	# t7 = &spiral[i * n + j]
			sw $s4, 0($t7)		# spiral[i * n + j] = aijValue;
			addi $s4, $s4, 1	# aijValue++
			addi $s6, $s6, 1		# j++
		j for_loop_3
		exit_for_loop_3:
	
		addi $s5, $s1, 0 # i  = row-2
		addi $s6, $s2, 0 # j = col-1
		for_loop_4:
			ble $s5, $s0, exit_for_loop_4	# if s5 (i) <= s0 (row-1), exit for_loop
			mul $t7, $a1, $s5 	# t7 = i * n 
			add $t7, $t7, $s6	# s7 (index value)  = i * n + j 
			sll $t7, $t7, 2		# t7 = aij value * 4 (for address indexing)
			add $t7, $t7, $a0	# t7 = &spiral[i * n + j]
			sw $s4, 0($t7)		# spiral[i * n + j] = aijValue;
			addi $s4, $s4, 1	# aijValue++
			addi $s5, $s5, -1		# i--
		j for_loop_4
		exit_for_loop_4:
		
		addi $s0, $s0, 1	#row1++
		addi $s1, $s1, -1	#row2--
		addi $s2, $s2, -1	#column1--
		addi $s3, $s3, 1	#column2++

		j while
	exit_while:

	lw $ra, 0($sp)
	lw $s6, 4($sp)
	lw $s5, 8($sp)
	lw $s4, 12($sp)
	lw $s3, 16($sp)
	lw $s2, 20($sp)
	lw $s1, 24($sp)
	lw $s0, 28($sp)
	
	add $sp, $sp, 32
	jr $ra		



# print matrix
# $a1 base address of the matrix
# $a2 number of rows/columns
print:
	addi 	$sp, $sp, -4
	sw 	$ra, 0($sp)

	addi $t1,$zero,0 # $t1 = 0, iterator i
	addi $t2,$zero,0 # $t2 = 0. iterator j
	move $t3,$a1     # address of the matrix

	print_loop_i:
	slt $t4,$t1,$a2 # i<# row
	beq $t4,$zero,exit_print
	addi $t2,$zero,0
	
	print_loop_j:
	slt $t4,$t2,$a2 # j<# col
	beq $t4,$zero,print_increase_i
	
	lw $t5,0($t3)   # print matrix value 
	add $a0,$t5,$zero 
	addi $v0, $zero, 1
	syscall
	
	la $a0,space # cout << ' '
	addi $v0, $zero, 4
	syscall 	
	
	addi $t3,$t3,4
	addi $t2,$t2,1
	
	j print_loop_j
	
	print_increase_i:
	la $a0, newline # cout << endl
	addi $v0, $zero, 4
	syscall 
		
	addi $t1,$t1,1
	j print_loop_i
	
	exit_print:
	lw 	$ra, 0($sp)
        addi 	$sp, $sp, 4
	jr $ra
