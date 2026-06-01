	.file	"3.61.c"
	.text
	.globl	cread
	.type	cread, @function
cread:
.LFB0:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L3
	movq	(%rdi), %rax
	ret
.L3:
	movl	$0, %eax
	ret
	.cfi_endproc
.LFE0:
	.size	cread, .-cread
	.globl	cread_alt
	.type	cread_alt, @function
cread_alt:
.LFB1:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L6
	movq	(%rdi), %rax
	ret
.L6:
	movl	$0, %eax
	ret
	.cfi_endproc
.LFE1:
	.size	cread_alt, .-cread_alt
	.ident	"GCC: (Ubuntu 15.2.0-16ubuntu1) 15.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
