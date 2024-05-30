.section .data
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
    // zero out xmm0
    xorps   %xmm0, %xmm0

.upper_loop:
    cmp    $0, %rdx
    je .end_upper_loop
    movaps (%rdi), %xmm1
    movaps (%rsi), %xmm2

    // a[i] * b[i]
    mulps %xmm2, %xmm1
    // sum += a[i] * b[i]
    addps %xmm1, %xmm0  

    // move to next element
    addq $16, %rdi 
    // move to next element
    addq $16, %rsi 
    // decrement counter
    sub  $4, %rdx 

    jmp .upper_loop
.end_upper_loop:
    // horizontal sum of xmm0

    // xmm1 = xmm0[2], xmm0[3], xmm0[2], xmm0[3]
    movhlps %xmm0, %xmm1 
    // xmm0[0] + xmm0[2], xmm0[1] + xmm0[3], xmm0[2], xmm0[3]
    addps %xmm1, %xmm0 
    // xmm1 = xmm0[0] + xmm0[2], xmm0[1] + xmm0[3], xmm0[2], xmm0[3]
    movaps %xmm0, %xmm1 
    // xmm1 = xmm0[1] + xmm0[3], xmm0[1] + xmm0[3], xmm0[1] + xmm0[3], xmm0[1] + xmm0[3]
    shufps $0x55, %xmm1, %xmm1 
    // xmm0[0] + xmm0[1] + xmm0[2] + xmm0[3], xmm0[1] + xmm0[3], xmm0[2], xmm0[3]
    addps %xmm1, %xmm0 

.second_part:
    // result in xmm0
    // 1 xmm1 to store the running multipication
    xorps %xmm1, %xmm1
    // load 1 to each cell
    xor %rdx, %rdx
    inc %rdx
    // movss $1.0, %xmm1
    pop %rdx
    pop %rsi
    pop %rdi
    movq $0,%r8
// calculate mul(a[i]^2+b[i]^2-2*x[i]*y[i]+1) from i=1 to size
.lower_loop:
    cmp   $0, %rdx
    je .end_lower_loop

    movaps (%rdi), %xmm2
    movaps (%rsi), %xmm3

    // x-y
    subps %xmm2, %xmm3
    // store (x-y)^2 in xmm3
    mulps %xmm3, %xmm3
    // store ((x-y)^2)+1 in xmm3
    addps %xmm5, %xmm3

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
    // multiple the float cells in xmm1
    // xmm2 = xmm1[2], xmm1[3], xmm1[2], xmm1[3]
    movhlps %xmm1, %xmm2
    // xmm1[0] * xmm1[2], xmm1[1] * xmm1[3], xmm1[2], xmm1[3]
    mulps %xmm2, %xmm1
    // xmm2 = xmm1[0] * xmm1[2], xmm1[1] * xmm1[3], xmm1[2], xmm1[3]
    movaps %xmm1, %xmm2
    // xmm2 = xmm1[1] * xmm1[3], xmm1[1] * xmm1[3], xmm1[1] * xmm1[3], xmm1[1] * xmm1[3]
    shufps $0x55, %xmm2, %xmm2
    // xmm1[0] * xmm1[2] * xmm1[1] * xmm1[3], xmm1[1] * xmm1[3], xmm1[2], xmm1[3]
    mulps %xmm2, %xmm1

.end_equistion:
    // divide xmm0 by xmm1
    divps %xmm1,%xmm0 

end:
    movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret
