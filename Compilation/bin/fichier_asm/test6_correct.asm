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
add:
	push rbp
	mov rbp, rsp
	sub rsp, 8
	;If
	;Identifier
	mov rax, rbp
	add rax, 8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Identifier
	mov rax, rbp
	add rax, -8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;traitement Inf
	pop rax
	pop rcx
	cmp rax, rcx
	jg isNotInf0
	push 0
	jmp restInf0
	isNotInf0:
	push 1
	restInf0:
	pop rax
	cmp rax, 1
	jne not_if0
	;IntLiteral
	push 1
	;return
	pop rax
	not_if0:
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
	pop rbp
	ret
main:
	mov rbp, rsp
	sub rsp, 0
	;function add
	call add
	push rax
	;IntLiteral
	push 0
	;return
	pop rax
	;fin
	mov rsp, rbp
	ret
