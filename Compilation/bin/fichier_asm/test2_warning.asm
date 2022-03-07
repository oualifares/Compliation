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
trinome:
	push rbp
	mov rbp, rsp
	mov [rbp -8], rdi
	mov [rbp -16], rsi
	mov [rbp -24], rdx
	sub rsp, 24
	;Identifier
	mov rax, rbp
	add rax, 24
	push rax
	;Identifier
	mov rax, rbp
	add rax, -16
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
	;Mult
	pop rbx
	pop rax
	imul rax, rbx
	push rax
	;IntLiteral
	push 4
	;Identifier
	mov rax, rbp
	add rax, -8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Mult
	pop rbx
	pop rax
	imul rax, rbx
	push rax
	;Identifier
	mov rax, rbp
	add rax, -24
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Mult
	pop rbx
	pop rax
	imul rax, rbx
	push rax
	;Sub
	pop rbx
	pop rax
	sub rax, rbx
	push rax
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;If
	;Identifier
	mov rax, rbp
	add rax, 24
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;IntLiteral
	push 0
	;traitement SupOrEq
	pop rax
	pop rcx
	cmp rax, rcx
	jng isNotSupOrEq0
	push 0
	jmp restSupOrEq0
	isNotSupOrEq0:
	push 1
	restSupOrEq0:
	pop rax
	cmp rax, 1
	jne not_if0
	;Identifier
	mov rax, rbp
	add rax, 8
	push rax
	;Identifier
	mov rax, rbp
	add rax, -16
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Identifier
	mov rax, rbp
	add rax, 32
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Add
	pop rbx
	pop rax
	add rax, rbx
	push rax
	;IntLiteral
	push 2
	;Identifier
	mov rax, rbp
	add rax, -8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Mult
	pop rbx
	pop rax
	imul rax, rbx
	push rax
	;Div
	pop rcx
	pop rax
	mov rdx , 0
	idiv rcx
	push rax
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;Identifier
	mov rax, rbp
	add rax, 16
	push rax
	;Identifier
	mov rax, rbp
	add rax, -16
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Identifier
	mov rax, rbp
	add rax, 32
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Sub
	pop rbx
	pop rax
	sub rax, rbx
	push rax
	;IntLiteral
	push 2
	;Identifier
	mov rax, rbp
	add rax, -8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Mult
	pop rbx
	pop rax
	imul rax, rbx
	push rax
	;Div
	pop rcx
	pop rax
	mov rdx , 0
	idiv rcx
	push rax
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;IntLiteral
	push 1
	;return
	pop rax
	not_if0:
	;CharLiteral
	push 'a'
	;return
	pop rax
	;fin
	mov rsp, rbp
	pop rbp
	ret
valeur:
	push rbp
	mov rbp, rsp
	mov [rbp -8], rdi
	mov [rbp -16], rsi
	mov [rbp -24], rdx
	mov [rbp -32], rcx
	sub rsp, 32
	;Identifier
	mov rax, rbp
	add rax, -8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Identifier
	mov rax, rbp
	add rax, -32
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Mult
	pop rbx
	pop rax
	imul rax, rbx
	push rax
	;Identifier
	mov rax, rbp
	add rax, -32
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Mult
	pop rbx
	pop rax
	imul rax, rbx
	push rax
	;Identifier
	mov rax, rbp
	add rax, -16
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Identifier
	mov rax, rbp
	add rax, -32
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Mult
	pop rbx
	pop rax
	imul rax, rbx
	push rax
	;Add
	pop rbx
	pop rax
	add rax, rbx
	push rax
	;Identifier
	mov rax, rbp
	add rax, -24
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
main:
	mov rbp, rsp
	sub rsp, 16
	;Identifier
	mov rax, rbp
	add rax, -8
	push rax
	;IntLiteral
	push 1
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;While
	while0:
	;Identifier
	mov rax, rbp
	add rax, -8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;IntLiteral
	push 1
	;traitement InfOrEq
	pop rax
	pop rcx
	cmp rcx, rax
	jng isNotInfOrEq0
	push 0
	jmp restInfOrEq0
	isNotInfOrEq0:
	push 1
	restInfOrEq0:
	pop rax
	cmp rax, 1
	jne finWhile0
	;Identifier
	mov rax, rbp
	add rax, -16
	push rax
	;IntLiteral
	push 1
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	;While
	while1:
	;Identifier
	mov rax, rbp
	add rax, -16
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;CharLiteral
	push 'a'
	;traitement InfOrEq
	pop rax
	pop rcx
	cmp rcx, rax
	jng isNotInfOrEq1
	push 0
	jmp restInfOrEq1
	isNotInfOrEq1:
	push 1
	restInfOrEq1:
	pop rax
	cmp rax, 1
	jne finWhile1
	;Identifier
	mov rax, rbp
	add rax, -8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Print
	mov rdi, __format_int_print
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
	;If
	;IntLiteral
	push 1
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
	;function trinome
	pop rdx
	pop rsi
	pop rdi
	call trinome
	push rax
	pop rax
	cmp rax, 1
	jne not_if1
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
	;Identifier
	mov rax, rbp
	add rax, 16
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;Print
	mov rdi, __format_int_print
	pop rsi
	xor rax, rax
	call printf
	not_if1:
	;Identifier
	mov rax, rbp
	add rax, -16
	push rax
	;Identifier
	mov rax, rbp
	add rax, -16
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;IntLiteral
	push 1
	;Add
	pop rbx
	pop rax
	add rax, rbx
	push rax
	;Assigne
	pop rbx
	pop rax
	mov qword [rax], rbx
	jmp while1
	finWhile1:
	;Identifier
	mov rax, rbp
	add rax, -8
	push rax
	;Identifier
	mov rax, rbp
	add rax, -8
	push rax
	;ValueOf
	pop rax
	push qword [rax]
	;IntLiteral
	push 1
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
	;IntLiteral
	push 0
	;return
	pop rax
	;fin
	mov rsp, rbp
	ret
