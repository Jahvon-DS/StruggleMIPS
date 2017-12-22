.data 
 message: .ascii "Wassup, please input integers "
 userInput: .byte 0:10000
 whitespace: .asciiz "This is white space\n" 
 newArray: .word 0:10000
 saving_Array: .word 0:10000
 onesArrays:    .word  0:100
 countMessage: .asciiz "\nAmount of Ints:"
 whitespace2: .asciiz " "
 maxMessage:   .asciiz "\nThis is Max Integer: "
 binaryNumbers:  .asciiz "\nMax Binary Numbers: "
 binMessage: .asciiz "\nThis is the binary number"
 maxOnesMessagePrint: .asciiz "\nIntegers with the max number of 1s: "
 newLINE:	.asciiz "\n"
.text

main: 


#display msg.
li $v0, 4
la $a0, message
syscall

#getting user input
li $v0, 8
la $a0, userInput
li $a1, 10000
syscall

la $t0, userInput 
#beq $a0, 32, whitespace_method


jal loop

la $t2, userInput #load userinput into this register 
jal store_userInput 

addi $s0,$zero,0 #counter for the integers
jal trueLoop
#syscall to end the program 

li $v0, 10 
syscall

largest:
  addi $t7,$t7,4
  addi $t8,$t8,4
 move $s0, $t5
 addi $t5 , $zero, 0
 j trueLoop
#function to get white space
 whitespace_method: 
li $v0, 4  
la $a0, whitespace
syscall
addi $t0,$t0, 1

j secondLoop 
  jr $ra
  
#loopFindWhite:   lb $a0, 0($t0) 
 #blt $a0, 48 whitespace_method
 #bgt $a0, 57 whitespace_method
 #beq $a0, 
  
  loop: lb $a1, 0 ($t0)
  li $v0,1
  la $a0,($a1)
  #syscall <-- used to print out the ascii numbers along with int numbers
  
  
  beq $a1, 32, whitespace_method
secondLoop:
beqz $a1,exit
bne $a1, 32, increment

bne $a1, 9, increment 
beq $a1, 9, whitespace_method
 j loop 
 
 increment: addi $t0,$t0, 1
  #beqz $a1,exit
  j loop

exit:
jr $ra 

#convert ascii to decimal by adding -48 --> difference 
#btwn ascii val of any given digit 
store_userInput: 
 lb $t1, 0 ($t2)
 addi $t3, $t1, -48
 
 #li $v0,1
 #la $a0,($t3)
 #syscall

 
  addi $t2, $t2, 1
   
sw $t3, newArray($t4)   
lw $s1, newArray($t4) 
addi $t4, $t4, 4

 
beqz $t1, exit 
#li $v0, 1 
#la $a0, ($s1)  
#syscall 
j store_userInput


trueLoop:
lw $t6, newArray($t7) 

beq $t6,-48,counter
beq $t6, -16, increment_2
beq $t6,-39,increment_2
beq $t6,-38,increment_2

# bne $t6,-16 , math 
 

math: 
 mul $t5, $t5,10
 add $t5, $t5,$t6
 
 addi $t7,$t7, 4
 
j trueLoop 
 #lb $t0,
  

increment_2:
bne $t5, 0, store_Array 
 
addi $t5, $zero, 0 
addi $t7, $t7, 4


j trueLoop

# also attempt at binary conversion
#storing the numbers and also finding the max value
store_Array: 
 sw $t5, saving_Array($t8)
 blt $s0, $t5, largest 
 
 addi $t5 , $zero, 0
 
 addi $t7,$t7,4
 addi $t8,$t8,4
 

 j trueLoop

counter:
lw $s3,saving_Array($s6)


 
 addi $s6,$s6,4
 beqz $s3,printCounter
 li $v0,1
 la $a0,($s3)
 syscall
 
 li $v0,4
 la $a0,whitespace2
 syscall
 addi $s2,$s2,1
 
 div $t1, $t6, 2
 
 j counter
printCounter: 
li $v0,4
la $a0,countMessage
syscall

li $v0,1
la $a0,($s2)
syscall

li $v0,4
la $a0,maxMessage
syscall

li $v0,1
la $a0,($s0)
syscall


addi $s4,$zero,0
addi $s6,$zero,0
addi $t3,$zero,0
addi $t1,$zero,0
addi $s7,$zero,0
addi $s2,$zero,0
addi $t7,$zero,0
#loop for findding the bin
bin_loop:
lw $s4,saving_Array($s6) 
beqz $s4, max
divide:
rem $t3, $s4 2
div $s4, $s4, 2 
beq $t3, 1, increment2 
beqz $s4, Next_Array
j divide 

Next_Array: 
addi $s6, $s6, 4 
sw $s7,onesArrays($t7)

addi $s7,$zero,0
addi $t7,$t7,4
j bin_loop 
increment2: 
addi $s7,$s7, 1 
j divide

 max:
 addi $t2,$zero,0
 addi $s7,$zero,0
 addi $t7,$zero,0
 getMaxOnes:
lw $t2,onesArrays($t7) 

blt $s7,$t2,maxStorage
beqz $t2,printThatMax
addi $t7,$t7,4
  
  
  j getMaxOnes
maxStorage:
move $s7,$t2
addi $t7,$t7,4
j getMaxOnes  
printThatMax:
li $v0,4
la $a0,binaryNumbers
syscall

li $v0,1
la $a0,($s7)
syscall

li $v0,4
la $a0,maxOnesMessagePrint
syscall

addi $s4,$zero,0
addi $s6,$zero,0
addi $t3,$zero,0
addi $t1,$zero,0
addi $s2,$zero,0
addi $s1,$zero,0
addi $t7,$zero,0
#loop for findding the bin
bin_loop2:
lw $s4,saving_Array($s6) 
beqz $s4, quit
divide2:
rem $t3, $s4 2
div $s4, $s4, 2 
beq $t3, 1, increment3 
beqz $s4, Next_Array2
j divide2 

Next_Array2: 
beq $s2,$s7,printNumsWithMaxOnes

addi $s6, $s6, 4 

addi $s2,$zero,0
addi $t7,$t7,4
j bin_loop2 
increment3: 
addi $s2,$s2, 1 
j divide2

quit:
li $v0,10
syscall


## allows for the code to be commpiled at the moment 
printNumsWithMaxOnes:
lw $s1,saving_Array($s6)

li $v0,1
la $a0,($s1)
syscall

#allows word to go to new line 
li $v0,4
la $a0,newLINE
syscall
addi $s6,$s6,4
addi $s2,$zero,0
j bin_loop2
