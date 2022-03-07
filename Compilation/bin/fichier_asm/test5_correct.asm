global _start
extern print_registers
extern printf
extern scanf
__static:
	resb 8
section .data
	__format_int_print db "%d", 10, 0
	__format_char_print db "%c", 10, 0
	__format_int_reade db "%d", 0
	__format_int_readc db "%c", 0
section .text
_start:
	call main
	mov rax, 60
	mov rdi, 0
	syscall
main:
	mov rbp, rsp
	sub rsp, 24
	;Identifier
	mov rax, rbp
	add rax, 8
	push rax
	;IntLiteral
	push 3
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;Identifier
	mov rax, rbp
	add rax, -8
	push rax
	;CharLiteral
	push 'c'
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;IntLiteral
	push 1
	;Print
	mov rdi, __format_int_print
	pop rsi
	xor rax, rax
	call printf
	;Identifier
	mov rax, rbp
	add rax, 8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;return
	pop rax
	;fin
	mov rsp, rbp
	ret
