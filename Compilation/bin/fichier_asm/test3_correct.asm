global _start
extern print_registers
extern printf
extern scanf
__static:
	resb 16
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
printf:
	push rbp
	mov rbp, rsp
	sub rsp, 0
	;Identifier
	mov rax, rbp
	add rax, 8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Identifier
	mov rax, rbp
	add rax, 16
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Add
	pop rbx
	pop rax
	add rax, rbx
	push rax
	;return
	pop rax
	;fin
	mov rsp, rbp
	pop rbp
	ret
zeekf:
	push rbp
	mov rbp, rsp
	mov [rbp -8], rdi
	mov [rbp -16], rsi
	sub rsp, 16
	;function printf
	call printf
	push rax
	;fin
	mov rsp, rbp
	pop rbp
	ret
main:
	mov rbp, rsp
	sub rsp, 16
	;Identifier
	mov rax, rbp
	add rax, -8
	push rax
	;IntLiteral
	push 5
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;Identifier
	mov rax, rbp
	add rax, -16
	push rax
	;IntLiteral
	push 12
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
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
	add rax, 16
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
	add rax, -8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Identifier
	mov rax, rbp
	add rax, -16
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;function zeekf
	pop rsi
	pop rdi
	call zeekf
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
