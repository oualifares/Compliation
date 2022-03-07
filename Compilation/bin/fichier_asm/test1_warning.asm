global _start
extern print_registers
extern printf
extern scanf
__static:
	resb 88
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
	mov [rbp -8], rdi
	mov [rbp -16], rsi
	mov [rbp -24], rdx
	sub rsp, 40
	;Identifier
	mov rax, rbp
	add rax, -40
	push rax
	;CharLiteral
	push 'r'
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;Pointers 
	mov rax, rbp
	add rax, -32
	push qword [rax]
	;IntLiteral
	push 12
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;Identifier
	mov rax, rbp
	add rax, 40
	push rax
	;IntLiteral
	push 24
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;Identifier
	mov rax, rbp
	add rax, 8
	push rax
	;Pointers 
	mov rax, rbp
	add rax, -32
	push qword [rax]
	;Pointers 
	mov rax, rbp
	add rax, 40
	push qword [rax]
	;Add
	pop rbx
	pop rax
	add rax, rbx
	push rax
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;Identifier
	mov rax, rbp
	add rax, 88
	push rax
	;CharLiteral
	push '.'
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;fin
	mov rsp, rbp
	ret
test:
	push rbp
	mov rbp, rsp
	mov [rbp -8], rdi
	mov [rbp -16], rsi
	sub rsp, 32
	;Identifier
	mov rax, rbp
	add rax, -24
	push rax
	;Pointers 
	mov rax, rbp
	add rax, 56
	push qword [rax]
	;Identifier
	mov rax, rbp
	add rax, 64
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Add
	pop rbx
	pop rax
	add rax, rbx
	push rax
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;Identifier
	mov rax, rbp
	add rax, -32
	push rax
	;CharLiteral
	push 'c'
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;fin
	mov rsp, rbp
	pop rbp
	ret
