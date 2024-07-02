# Projeto: Testando instruções do Simulador de processador MIPS
# Arquivo: testador-instrucoes.asm
# Descrição:
# Autores: Maria Rita Piekas e Nathália Zófoli
# data da criação: 01/07/2024
.text
##############################################

## Carrega em IR um valor fictício para simular a instrução que queremos testar 
	la $s0, IR ## carrega endereço de IR
	li $t0, 0x24bdfff8	## carrega um valor equivalente à instrução que se quer testar
	sw $t0, 0($s0)		## armazena em IR o valor em $t0
	
decodificaInstrucao: 
	lw $a0, IR
	srl $s0, $a0, 26 		## $s0 = campo OPCODE
	andi $s1, $a0, 0x0000003F 	## $s1 = campo FUNCT
	srl $s2, $a0, 6 		## $s2 = campo shamt
	andi $s2, $s2, 0x0000001F
	srl $s3, $a0, 11 		## $s3 = campo rd
	andi $s3, $s3, 0x0000001F
	srl $s4, $a0, 16 		## $s4 = campo rt
	andi $s4, $s4, 0x0000001F
	srl $s5, $a0, 21 		## $s5 = campo rs
	andi $s5, $s5, 0x0000001F
	sll $s6, $s5, 1
	
	#testando "juntador" de instrução I
	sll $t0, $s3, 11 ## puxa campo rd 11 bits para esquerda
	sll $t1, $s2, 6 ## puxa campo shamt 6 bits para esquerda
	add $t2, $t1, $t0
	add $t2, $t2, $s1
	
	##lw $a0, IR
	##srl $t0, $a0, 26 		## $t0 = campo OPCODE
	##andi $t1, $a0, 0x0000003F 	## $t1 = campo FUNCT
	##srl $t2, $a0, 6 		## $t2 = campo shamt
	##andi $t2, $t2, 0x0000001F
	##srl $t3, $a0, 11 		## $t3 = campo rd
	##andi $t3, $t3, 0x0000001F
	##srl $t4, $a0, 16 		## $t4 = campo rt
	##andi $t4, $t4, 0x0000001F
	##srl $t5, $a0, 21 		## $t5 = campo rs
	##andi $t5, $t5, 0x0000001F
	##sll $t6, $t5, 1

	## Em vez de fazer todos esses testes, trocar o segundo argumento por um igual ao da instrução
	## que estamos testando
	beq $t0, $zero, instrucaoR
	li $t7, 2		
	beq $t0, $t7, instrucaoJ
	li $t7, 3		
	beq $t0, $t7, instrucaoJ
	li $t7, 4		 ### ?????????
	beq $t0, $t7, instrucaoJ ### ?????????
	li $t7, 8		
	beq $t0, $t7, instrucaoI
	li $t7, 9		
	beq $t0, $t7, instrucaoI
	
	beq $t0, $t7, instrucaoJ
	
## Aqui também, coloca só o número da instrução que vamos testar e executa ela
## Olhar na label "regs" se executou da maneira esperada
instrucaoR:
	li $t7, 0x20
	

instrucaoI:

instrucaoJ:	

#fimDecodificaInstrucao:
	
	
	
##############################################
encerraPrograma:
	li $v0, 17
	syscall			# faz a chamada 17 e encerra o programa	


.data
	PC: .word 0
	IR: .word 0
	regs: .space 128 ## Registradores do simulador
	buffer_leitura: .space 4  ## Buffer para leitura do arquivo de entrada. Armazena 4 bytes por vez
	memoria_text: .space 1024
	memoria_data: .space 1024
	memoria_pilha: .space 1024
	endereco_texto: .word 0x1001008c
	endereco_data: .word 0x10010000
	endereco_pilha: .word 0x7FFFEFFC
	local_arquivo: .asciiz "/home/nathizofoli/Documentos/workspace/T1-org/trabalho_01-2024_1.bin"
	descritor_arquivo: .word 0
# Máscaras para decodificar a instrução
	#campo_rd:
	#campo_rs:
	#campo_rt:
	#campo_imm:
