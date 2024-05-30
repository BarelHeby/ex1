hamming_dist:
    push %rbp
    mov %sp, %rbp


    // first arg to rdi, second arg to rsi
    movdqu (%rdi),%xmm1
    movdqu (%rsi),%xmm2 

    // check mask on two string using pcmpistri instruction
    mov $0x0,%rax
    mov $0x0,%rcx
    mov $0x0,%rdx
    mov $0x0,%r8
    mov $0x0,%r9
    mov $0x0,%r10
    mov $0x0,%r11
    mov $0x0,%r12
    mov $0x0,%r13
    mov $0x0,%r14
    