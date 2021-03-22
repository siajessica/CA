.globl __start

.rodata
    divide_by_zero: .string "divide by zero"

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0
    
    beq s1 x0 op0
    addi s4 x0 1
    beq s4 s1 op1
    addi s4 s4 1
    beq s4 s1 op2
    addi s4 s4 1
    beq s4 s1 op3
    addi s4 s4 1
    beq s4 s1 op4
    addi s4 s4 1
    beq s4 s1 op5
    j exit
    
op0:
  add s3 s0 s2
  j exit
  
op1:
  sub s3 s0 s2
  j exit

op2:
  mul s3 s0 s2
  j exit

op3:
  beq s2 x0 zero_except
  div s3 s0 s2
  j exit

op4:
  blt s2 x0 exit
  addi s3 x0 1
  beq s2 x0 exit
  beq x0 x0 op4loop
  
op4loop:
  beq s2 s5 exit
  addi s5 s5 1
  mul s3 s3 s0
  beq x0 x0 op4loop

op5:
  blt s0 x0 exit
  addi s3 x0 1
  beq s0 x0 exit
  addi s5 x0 1
  beq x0 x0 op5loop
  
op5loop:
  beq s0 s5 exit
  addi s5 s5 1
  mul s3 s3 s5
  beq x0 x0 op5loop

exit:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall
    # Exit program(necessary)
    li a0, 10
    ecall

zero_except:
    # Divide by zero exception
    li a0, 4
    la a1, divide_by_zero
    ecall
    # Exit the program(necessary)
    li a0, 10
    ecall
