.section .data
imm: .quad 01001000

.section .text
.global hamming_dist

hamming_dist:
    pushq 	%rbp
	movq 	%rsp,%rbp
    pushq %rbx
    // first arg to rdi, second arg to rsi
    movdqu (%rdi),%xmm1
    movdqu (%rsi),%xmm2 
    // check if the two strings are equal
    // result in xmm0 (0 if equal, 1 if not equal)
    xorq %rax, %rax
    xorq %rcx, %rcx
    pxor %xmm0, %xmm0
    // calculate haming distance
    pcmpistrm $0b01001000 , %xmm1, %xmm2 
    // result in xmm0
    xor %rax,%rax
    xor %rdx,%rdx
.loop:
    movq %xmm0,%rbx
    mov $8,%rcx
.sum_loop:
    cmp $0x00,%rcx
    je end
    movzx %bl,%rdx
    cmp $0x00,%rdx
    jne .not_zz
    inc %rax
.not_zz:
    shr $8,%rbx 
    dec %rcx
    jmp .sum_loop
end:
    popq %rbx
    movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret
