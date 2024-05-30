.section .data
imm: .quad 01001000

.section .text
.global formula2

formula2:
    pushq 	%rbp
	movq 	%rsp,%rbp
end:
    movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret
