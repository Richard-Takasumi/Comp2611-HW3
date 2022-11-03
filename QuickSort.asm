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


# This function does the same thing as the function Partition() in the C++ program
# arguments are in $a0, $a1 and $a2.
# $a0: base address of array A[]
# $a1: index of starting element
# $a2: index of the end element 
# Be careful to use sle instruction when you perform 'less than and equal' operation
# You should select the first element of the array as the 'pivot' element.
# Remeber to preserve registers as needed	
Partition:



# This function does the same thing as the function Swap() in the C++ program
# arguments are in $a0, $a1 and $a2.
# $a0: base address of array A[]
# $a1: index of one element
# $a2: index of the other element to be swapped in the array
# You should use the registers $t4-$t7 when you need the temporary registers.
# Remeber to preserve registers as needed		
Swap:


	
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
