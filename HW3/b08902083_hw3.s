.globl __start

.text
__start:
    #constant
    addi x31 x0 2
    
    #Read first operand in x5
    addi x10 x0 5
    ecall
    add x5 x10 x0
    
    jal x1 t_rec
    jal x0 exit
    
#arg in x10, return in x11
t_rec:
    blt x5 x31 trivial #if n < 2
    
    #setup
    addi x2 x2 -32 #reserve stack
    sw x1 24(x2) #save ra
    sw x5 16(x2) #save n
    
    #if (n-100)>=2 , jump
    add x6 x0 x5
    addi x6 x6 -100
    bge x6 x31 sub_n
    #else
    addi x10 x0 1
    sw x10 8(x2)
    
    #if (n/2) >= 2, jump
    add x6 x0 x5
    div x6 x6 x31
    bge x6 x31 div_n
    #else
    addi x11 x0 1
    sw x11 0(x2)
    
    #count T(n)
    mul x11 x11 x31 #ret = 2*T(n/2)
    addi x11 x11 5 #ret = ret + 5
    add x11 x11 x10
    
    #return
    addi x2 x2 32
    jalr x0 x1 0
    
trivial:
    addi x11 x0 1
    beq x0 x0 exit
    
sub_n:
    #recursive count T(n-100)
    addi x5 x5 -100
    jal x1 t_rec
    
    #save T(n-100)
    add x10 x0 x11
    sw x10 8(x2)
    
    #load
    lw x1 24(x2)
    lw x5 16(x2)   
    
    #if (n/2) >= 2, jump
    add x6 x0 x5
    div x6 x6 x31
    bge x6 x31 div_n
    #else
    addi x11 x0 1
    sw x11 0(x2)
    
    #count T(n)
    mul x11 x11 x31 #ret = 2*T(n/2)
    addi x11 x11 5 #ret = ret + 5
    add x11 x11 x10
    
    #return
    addi x2 x2 32
    jalr x0 x1 0
    
div_n:
    #recursive count T(n/2)
    div x5 x5 x31
    jal x1 t_rec
    
    sw x11 0(x2) #save
    
    #load
    lw x1 24(x2)
    lw x5 16(x2)
    lw x10 8(x2)
    
    #count T(n)
    mul x11 x11 x31 #ret = 2*T(n/2)
    addi x11 x11 5 #ret = ret + 5
    add x11 x11 x10
    
    #return
    addi x2 x2 32
    jalr x0 x1 0
  
exit:
    # Output the result
    addi x10 x0 1
    ecall
    
    # Exit program(necessary)
    addi x10 x0 10
    ecall