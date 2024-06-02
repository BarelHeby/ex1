.section .rodata
.align 16
val: .float 1.0, 1.0, 1.0, 1.0
.section .text
.global formula2

formula2:
    // args:
    // rdi - float * a - first array
    // rsi - float * b - second array
    // rdx - int n - number of elements
    pushq 	%rbp
	movq 	%rsp,%rbp
    // save args in stack
    pushq   %rdi
    pushq   %rsi
    pushq   %rdx 

.second_part:
    // result in xmm0
    // 1 xmm1 to store the running multipication
    pxor %xmm1, %xmm1

    // load 1 to each cell
    // xmm5 = [1,1,1,1]
    pxor %xmm5, %xmm5
    mov $0x3f800000,%eax
    movd %eax, %xmm5
    shufps $0x00, %xmm5, %xmm5 
    xor %r8, %r8
// calculate mul(a[i]^2+b[i]^2-2*x[i]*y[i]+1) from i=1 to size
.lower_loop:
    cmp   $0, %rdx
    je .end_lower_loop

    movaps (%rdi), %xmm2
    movaps (%rsi), %xmm3

    // a[i]-b[i]
    subps %xmm3, %xmm2

    // (a[i]-b[i])^2
    mulps %xmm2, %xmm2

    // add 1 to the result
    addps %xmm5, %xmm2

    // store the result in xmm3
    movaps %xmm2, %xmm3

    cmp $0, %r8
    je .first
    mulps %xmm3, %xmm1
.first:
    // store the result in xmm1
    addps %xmm3, %xmm1
    inc %r8

    // move to next element
    addq $16, %rdi 
    // move to next element
    addq $16, %rsi 
    // decrement counter
    sub  $4, %rdx 

    jmp .lower_loop
.end_lower_loop:
    // xmm1 = [x1,x2,x3,x4]
    // xmm2 = [x2,x3,x4,x1]
    // xmm3 = [x3,x4,x1,x2]
    // xmm4 = [x4,x1,x2,x3]
    movaps %xmm1,%xmm2
    pshufd $0x39, %xmm2, %xmm2  

    movaps %xmm2,%xmm3
    pshufd $0x39, %xmm3, %xmm3  

    movaps %xmm3,%xmm4
    pshufd $0x39, %xmm4, %xmm4  


    mulps %xmm2, %xmm1
    mulps %xmm3, %xmm1
    mulps %xmm4, %xmm1

.sum_totals:
    pop %rdx
    pop %rsi
    pop %rdi
    pxor %xmm4, %xmm4
.lp:
    cmp $0, %rdx
    je .end_totals
    movaps (%rdi), %xmm2
    movaps (%rsi), %xmm3

    // a[i] * b[i]
    mulps %xmm3, %xmm2
    
    divps %xmm2, %xmm1

    addps %xmm2, %xmm4

    // move to next element
    addq $16, %rdi
    // move to next element
    addq $16, %rsi
    // decrement counter
    sub $4, %rdx
    jmp .lp

.end_totals:
    movaps %xmm4, %xmm2
    pshufd $0x39, %xmm2, %xmm2

    movaps %xmm2, %xmm3
    pshufd $0x39, %xmm3, %xmm3

    movaps %xmm3, %xmm5
    pshufd $0x39, %xmm5, %xmm5

    addps %xmm2, %xmm4
    addps %xmm3, %xmm4
    addps %xmm5, %xmm4
    // return value
    movaps %xmm4, %xmm0
// .end_equistion:
    // divide xmm0 by xmm1
    // divps %xmm0,%xmm1 
    // movaps %xmm1, %xmm0
    // movaps %xmm1, %xmm0


end:
    movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret
