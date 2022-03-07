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
soustrait:
	push rbp
	mov rbp, rsp
	mov [rbp -8], rdi
	mov [rbp -16], rsi
	sub rsp, 16
	;Identifier
	mov rax, rbp
	add rax, -16
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Print
	mov rdi, __format_char_print
	pop rsi
	xor rax, rax
	call printf
	;Pointers 
	mov rax, rbp
	add rax, -8
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
decl:
	push rbp
	mov rbp, rsp
	mov [rbp -8], rdi
	mov [rbp -16], rsi
	sub rsp, 48
	;While
	while0:
	;IntLiteral
	push 1
	;IntLiteral
	push 2
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
	jne finWhile0
	;Identifier
	mov rax, rbp
	add rax, -24
	push rax
	;Identifier
	mov rax, rbp
	add rax, -8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Pointers 
	mov rax, rbp
	add rax, -32
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
	jmp while0
	finWhile0:
	;Identifier
	mov rax, rbp
	add rax, -40
	push rax
	;Identifier
	mov rax, rbp
	add rax, -48
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;function soustrait
	pop rsi
	pop rdi
	call soustrait
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
	;CharLiteral
	push '1'
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
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
	;function decl
	pop rsi
	pop rdi
	call decl
	;IntLiteral
	push 0
	;return
	pop rax
	;fin
	mov rsp, rbp
	ret
