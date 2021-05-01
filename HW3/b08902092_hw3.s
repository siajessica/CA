.globl __start

.text
__start:
    addi a0, x0, 5
    ecall

    jal x1, fact

    addi a0, x0, 1      # print value
    addi a1, s0, 0
    ecall            

    addi a0, x0, 10     # exit program
    ecall

#    addi a0, x0, 5
#    ecall
#    addi s1, a0, 0
    
#    addi a0, x0, 5
#    ecall
#    addi s2, a0, 0

#    addi a0, x0, 5
#    ecall
#    addi s3, a0, 0


#    jal x1, Leaf


fact:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw a0, 4(sp)

    addi t1, x0, 2
    bge a0, t1, recursion   # if n > 1 go to recursion
    addi s0, s0, 1          # else return 1

    lw a0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 8
    jalr x0, 0(x1)          # return

recursion:

    addi a0, a0, -100       # T(n-100)
    jal ra, fact

    addi s0, s0, 5          # T(n-100) + 2 x T(n/2) + 5

    addi a0, a0, 100
    addi t0, x0, 2
    div a0, a0, t0          # T(n/2)
    jal ra, fact
    jal ra, fact

    lw a0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 8

#    addi t0, x0, 2
#    mul t2, a0, t0          # 2 x T(n/2)
    jalr x0, 0(x1)







