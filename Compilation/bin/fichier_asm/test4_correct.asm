global _start
extern print_registers
extern printf
extern scanf
__static:
	resb 32
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
fct1:
	push rbp
	mov rbp, rsp
	mov [rbp -8], rdi
	sub rsp, 8
	;Identifier
	mov rax, rbp
	add rax, 8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Print
	mov rdi, __format_int_print
	pop rsi
	xor rax, rax
	call printf
	;fin
	mov rsp, rbp
	pop rbp
	ret
fct2:
	push rbp
	mov rbp, rsp
	mov [rbp -8], rdi
	mov [rbp -16], rsi
	sub rsp, 16
	;Identifier
	mov rax, rbp
	add rax, 32
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Print
	mov rdi, __format_char_print
	pop rsi
	xor rax, rax
	call printf
	;Identifier
	mov rax, rbp
	add rax, -16
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Print
	mov rdi, __format_int_print
	pop rsi
	xor rax, rax
	call printf
	;fin
	mov rsp, rbp
	pop rbp
	ret
fct:
	push rbp
	mov rbp, rsp
	mov [rbp -8], rdi
	sub rsp, 8
	;Identifier
	mov rax, rbp
	add rax, 32
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Print
	mov rdi, __format_char_print
	pop rsi
	xor rax, rax
	call printf
	;fin
	mov rsp, rbp
	pop rbp
	ret
main:
	mov rbp, rsp
	mov [rbp -8], rdi
	sub rsp, 24
	;If
	;IntLiteral
	push 1
	pop rax
	cmp rax, 1
	jne not_if0
	;IntLiteral
	push 1
	;IntLiteral
	push 1
	;Add
	pop rbx
	pop rax
	add rax, rbx
	push rax
	;return
	pop rax
	not_if0:
	;Pointers 
	mov rax, rbp
	add rax, -16
	push qword [rax]
	;Print
	mov rdi, __format_char_print
	pop rsi
	xor rax, rax
	call printf
	;Identifier
	mov rax, rbp
	add rax, 32
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;function fct
	pop rdi
	call fct
	;Identifier
	mov rax, rbp
	add rax, 32
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Identifier
	mov rax, rbp
	add rax, -24
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;function fct2
	pop rsi
	pop rdi
	call fct2
	;Identifier
	mov rax, rbp
	add rax, 8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;function fct1
	pop rdi
	call fct1
	;IntLiteral
	push 0
	;return
	pop rax
	;fin
	mov rsp, rbp
	ret
