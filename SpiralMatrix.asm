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
