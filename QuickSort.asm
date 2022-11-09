# Your name:
# Your student id:
# Your email address:

.data
# output messages
initMsg: .asciiz "Please enter integers in array A[] one by one:\n"
EnterNumberMsg1: 	.asciiz "A["
EnterNumberMsg2: 	.asciiz "]: "
SortedMsg:  .asciiz "The sorted array A[] is: "
space:		.asciiz " "
newline:		.asciiz "\n" 
# array A[] has 10 elements, each element is of the size of one word, 32 bits.
A: .word 0:10
# SIZE: the number of elements in array A[]
SIZE: .word 10

.text
# .globl main

main:
	la $s0,A        #$s0 base address of array A[]
	la $s1,SIZE
	lw $s1,0($s1)   #$s1 size of array A[]
	
	# cout << "Please enter integers in array A[] one by one:\n"
	la $a0, initMsg
	addi $v0, $zero, 4
	syscall
	
	li $t0,0  # iterator i
	
	input_array:
	beq $t0,$s1,exit_input
	
	# cout << "A["
	la $a0, EnterNumberMsg1
	addi $v0, $zero, 4
	syscall
	
	# print index
	move $a0,$t0
	addi $v0, $zero, 1
	syscall
	
	# cout << "]: "
	la $a0, EnterNumberMsg2
	addi $v0, $zero, 4
	syscall
	
	# read user input in $v0
	li $v0, 5
	syscall
	
	sll $t1,$t0,2
	add $t1,$t1,$s0 # $t1 = i*4 + base of A in $s0, addr of A[i]
	sw $v0, 0($t1)  # A[i] = $v0
	addi $t0,$t0,1
	j input_array
	
	exit_input:
	move $a0, $s0		# $a0 -> Address of the array
	li $a1, 0		# $a1 = start
	addi $a2, $s1, -1		# $a2 = end
	jal Quicksort
	
	jal PrintArray
	
	# return
	exit:
	addi $v0, $zero, 10 
	syscall


# This function does the same thing as the function Quicksort() in the C++ program
# arguments are in $a0, $a1 and $a2.
# $a0: base address of array A[]
# $a1: index of starting element
# $a2: index of the end element 
# Be careful to use sle instruction when you perform 'less than and equal' operation
# Remeber to preserve registers as needed	
Quicksort:
	addi $sp, $sp, -4	# make space in stack
	sw $ra, 0($sp)		# store $ra into stack
	
	
	ble $a2, $a1, exit_quicksort
	
	
	# callee responsibility
	addi $sp, $sp, -8 # make space in stack
	sw $s0, 0($sp)	# save s0 to stack
	sw $v0, 4($sp) 	# save $v0 to stack
	#callee responsibility
	

	jal Partition		# partition will return v0
	add $s0, $zero, $v0 	# save v0 value into s0

	# SORT LEFT PART
	#caller responsibility
	addi $sp, $sp, -8 # make space to save 2 function arguments
	sw $a1, 0($sp)	# save a1 (start)
	sw $a2, 4($sp)	# save a2 (end)

	addi $a2, $s0, -1 	# end = p - 1
	jal Quicksort


	lw $a1, 0($sp)	# load a1 from stack
	lw $a2, 4($sp)	# load a1 from stack
	addi $sp, $sp, 8 # remove space in stack
	# end_of_caller responsibility		
	
	# SORT RIGHT PART
	# start_caller responsibility
	addi $sp, $sp, -8 # make space to save 2 function arguments
	sw $a1, 0($sp)	# save a1 (start)
	sw $a2, 4($sp)	# save a2 (end)


	addi $a1, $s0, 1 	# end = p + 1
	jal Quicksort

	# start_caller responsibility	
	lw $a1, 0($sp)	# load a1 from stack
	lw $a2, 4($sp)	# load a1 from stack
	addi $sp, $sp, 8 # remove space in stack
	#end_of_caller responsibility		
	
	
	# callee responsibility
	lw $s0, 0($sp)  # restore s0 from stack
	lw $v0, 4($sp)	# restore v0 from stack
	addi $sp, $sp, 8 #remove space in stack
	#callee responsibility
	
	exit_quicksort:
	
	
	lw $ra, 0($sp)		# load ra from stack
	addi $sp, $sp, 4	# move pointer back up
	jr $ra			# jump to ra


# This function does the same thing as the function Partition() in the C++ program
# arguments are in $a0, $a1 and $a2.
# $a0: base address of array A[]
# $a1: index of starting element
# $a2: index of the end element 
# Be careful to use sle instruction when you perform 'less than and equal' operation
# You should select the first element of the array as the 'pivot' element.
# Remeber to preserve registers as needed	
# Partition is a caller and calee, which means it must save $t0-$t9, $a0-$a3 and $v0-$v1
Partition:
	addi $sp, $sp, -4	# make space in stack
	sw $ra, 0($sp)		# store $ra into stack
	
	
	#callee responsibility
	addi $sp, $sp, -12	# NEED TO SAVE s0-s7 registers
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	# callee responsibility
	

	sll $t0, $a1, 2 	# offset of start_index
	sll $t1, $a2, 2		# offset of end_index
	add $t2, $a0, $t0	# t2 stores the address of Arr[start_index]
	add $t3, $a0, $t1	# t3 stores the address of Arr[end_index]
	
	lw $s0, 0($t2) 		# s0 (pivot) = arr[start]
	li $s1, 0		# s1 (count) = 0
	addi $s2, $a1, 1	# s2 (iterator i) = start + 1
	
	
	for_loop_1:
	bgt $s2, $a2, exit_for_loop_1	# if i > end, exit loop
	sll $t4, $s2, 2 	# t4 = i * 4 for indexing
	add $t4, $t4, $a0	# t4 = address of arr[i] 
	lw $t4, 0($t4)		# t4 = arr[i]
	bgt $t4, $s0, skip	# if t4 > pivot, skip iteration
	
	addi $s1, $s1, 1	# count++
	skip:
	addi $s2, $s2, 1	# i++	
	j for_loop_1
	exit_for_loop_1:
	
	add $v0, $a1, $s1	# v0 (pivotIndex) = start + count
	
	
	# CALLER RESPONSIBILITY
	addi $sp, $sp, -36	# create space for 9 words in the stack
	sw $a0, 32($sp)		# store $a0
	sw $a1, 28($sp) 	# store $a1
	sw $a2, 24($sp) 	# store $a2
	sw $t0, 20($sp)		# store $t0
	sw $t1, 16($sp)		# store $t1
	sw $t2, 12($sp)		# store $t2
	sw $t3, 8($sp)		# store $t3
	sw $t4, 4($sp) 		# store $t4
	sw $v0, 0($sp) 		# store $v0
	
	add $t0, $a1, $zero	# temp store a1	
	add $t1, $a2, $zero	# temp store a2
	add $a1, $v0, $zero	# set start = pivotIndex
	add $a2, $t0, $zero	# end = start
	jal Swap 			# call swap( arr[], pivotIndex, start)
	add $a1, $t0, $zero	# restore a1
	add $a2, $t1, $zero	# restore a2
	
	lw $a0, 32($sp)		# restore $a0
	lw $a1, 28($sp) 	# restore $a1
	lw $a2, 24($sp) 	# restore $a2
	lw $t0, 20($sp)		# restore $t0
	lw $t1, 16($sp)		# restore $t1
	lw $t2, 12($sp)		# restore $t2
	lw $t3, 8($sp)		# restore $t3
	lw $t4, 4($sp) 		# restore $t4
	lw $v0, 0($sp) 		# restore $v0
	addi $sp, $sp, 36
	# END OF CALLER RESPONSIBILITY

	add $s1, $zero, $a1	# $s1 (i) = start
	add $s2, $zero, $a2	# $s2 (j) = end
	
	partition_while:
		slt $t0, $s1, $v0 # set t0 to 1 if i < pivotIndex
		sgt $t1, $s2, $v0 # set t1 to 1 if j > pivotIndex
		and $t1, $t0, $t1 #t1 will be set to 1 if both conditions are true
		beqz $t1, partition_while_exit 	# if either conditions are false, t1 will be 0, therefore exit the loop
	
		sll $t0, $s1, 2		# t0 = i * 4
		sll $t1, $s2, 2		# t1 = j * 4
		
		add $t2, $a0, $t0	# $t2 = &arr[i]
		add $t3, $a0, $t1	# $t3 = &arr[j]
		lw $t2, 0($t2)		# t2 = arr[i]
		lw $t3, 0($t3)		# t3 = arr[j]
		while_less_or_equal:
			bgt $t2, $s0, while_less_than_exit	# if arr[i] > pivot, exit the while loop
			addi $s1, $s1, 1	# i++
			sll $t0, $s1, 2		# t0 = i * 4
			add $t2, $a0, $t0	# $t2 = &arr[i]
			lw $t2, 0($t2)		# t2 = arr[i]
			
		j while_less_or_equal
		while_less_than_exit:
			
		#line to seperate while loops
		
		while_greater_than:
			ble $t3, $s0, while_greater_than_exit	# if arr[j] <= pivot, exit the while loop
			addi $s2, $s2, -1	# j--		
			sll $t1, $s2, 2		# t1 = j * 4
			add $t3, $a0, $t1	# $t3 = &arr[j]
			lw $t3, 0($t3)		# t3 = arr[j]
		j while_greater_than	
		while_greater_than_exit:

		slt $t0, $s1, $v0 # set t0 to 1 if i < pivotIndex
		sgt $t1, $s2, $v0 # set t1 to 1 if j > pivotIndex
		and $t1, $t0, $t1 #t1 will be set to 1 if both conditions are true
		beqz  $t1, pass_swap 	# if either is false, skip the function call
								
		# CALLER RESPONSIBILITY
		addi $sp, $sp, -36	# create space for 9 words in the stack
		sw $a0, 32($sp)		# store $a0
		sw $a1, 28($sp) 	# store $a1
		sw $a2, 24($sp) 	# store $a2
		sw $t0, 20($sp)		# store $t0
		sw $t1, 16($sp)		# store $t1
		sw $t2, 12($sp)		# store $t2
		sw $t3, 8($sp)		# store $t3
		sw $t4, 4($sp) 		# store $t4
		sw $v0, 0($sp) 		# store $v0
		
		add $a1, $s1, $zero	# set arguments of start = i
		add $a2, $s2, $zero	# set argument of end = j
		
		jal Swap 			# call swap( arr[], i, j)
		
		addi $s1, $s1, 1	# i++
		addi $s2, $s2, -1	# j--
		
		
		lw $a0, 32($sp)		# restore $a0
		lw $a1, 28($sp) 	# restore $a1
		lw $a2, 24($sp) 	# restore $a2
		lw $t0, 20($sp)		# restore $t0
		lw $t1, 16($sp)		# restore $t1
		lw $t2, 12($sp)		# restore $t2
		lw $t3, 8($sp)		# restore $t3
		lw $t4, 4($sp) 		# restore $t4
		lw $v0, 0($sp) 		# restore $v0
		addi $sp, $sp, 36
		# END OF CALLER RESPONSIBILITY
			
		pass_swap:
		

	j partition_while
	partition_while_exit:
	
	#callee responsibility
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	#callee responsibility

	lw $ra, 0($sp)		# load ra from stack
	addi $sp, $sp, 4	# move pointer back up
	jr $ra			# jump to ra



# This function does the same thing as the function Swap() in the C++ program
# arguments are in $a0, $a1 and $a2.
# $a0: base address of array A[]
# $a1: index of one element
# $a2: index of the other element to be swapped in the array
# You should use the registers $t4-$t7 when you need the temporary registers.
# Remeber to preserve registers as needed		
Swap:
	addi $sp, $sp, -4	# make space in stack
	sw $ra, 0($sp)		# store $ra into stack
	

	sll $t4, $a1, 2 	# offset of element_a index
	sll $t5, $a2, 2 	# offset of element_b index
	add $t4, $t4, $a0	# t4 stores address of arr[a_index]
	add $t5, $t5, $a0	# t5 stores address of arr[b_index]
	
	lw $t6, 0($t4)		# t6 stores the value of arr[a]
	lw $t7, 0($t5)		# t7 stores the value of arr[b]
	sw $t7, 0($t4)		# store value of arr[b] into address of arr[a]
	sw $t6, 0($t5)		# store value of arr[a] into address of arr[b]
	
	lw $ra, 0($sp)		# load ra from stack
	addi $sp, $sp, 4	# move pointer back up
	jr $ra			# jump to ra


	
PrintArray:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	#Print a new line
	la $a0, SortedMsg
	li $v0, 4
	syscall
        la  $t0, A           # get address of A
        ori $t1, $zero, 0    # counter  
       

print_A_loop:
        beq $t1, $s1, done_print_A
      
        li  $v0, 1
        sll $t2, $t1, 2
        add $t2, $t2, $t0
        lw  $a0, 0($t2)
        syscall

        # print space
        li  $v0, 4
        la  $a0, space
        syscall
        
        # update counters
        addi $t1, $t1, 1 
        j print_A_loop
        done_print_A:
	lw $ra,0($sp)
        addi $sp,$sp,4
        jr $ra
