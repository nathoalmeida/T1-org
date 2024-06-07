# Projeto: Simulador do processador MIPS
# Arquivo: simulador.asm
# Descrição:
# Autores: Maria Rita Piekas e Nathália Zófoli
# data da criação: 09/04/2024
.text
##############################################
aberturaArquivo:
	la $a0, local_arquivo 	  # carrega o endereço do arquivo em $a0
	li $a1, 0 		  # seta a flag do arquivo em 0 para modo de leitura
	la $a0, local_arquivo 	  # carrega o nome do arquivo em $a0
	li $v0, 13 		  # 0 = abre o arquivo em modo de leitura
	syscall			  # faz a chamada de sistema n. 13 para abrir o arquivo
	la $t0, descritor_arquivo # armazena em $t0 o endereço do descritor do arquivo
	sw $v0, 0($t0)		  # armazena em descritor_arquivo o valor de retorno da chamada	


## Testa a abertura do arquivo:
	add $t1, $zero, $t0	 # armazena em $t1 o valor de retorno da chamada 
	bltz $t1, encerraPrograma # se o retorno da chamada for negativo, houve erro na abertura do arquivo
	
	lw $a0, 0($t0)		# armazena o valor do descritor do arquivo em $a0 
	
leituraArquivo:	
	la $a1, buffer_leitura  # carrega em $a1 o endereço da variável buffer_leitura
	li $a2, 4		# carrega em $a2 o número de bytes que serão lidos do arquivo
	li $v0, 14		# carrega em $v0 a chamada que será feita ao sistema (14 = leitura arquivo)
	syscall
	
## Armazena o valor de buffer_leitura para memoria_text e incrementa o endereço de memoria_text
	lw $a2, endereco_texto	# carrega o endereço inicial de memoria_texto em $a2
	lw $a3, 0($a1) 		# carrega o valor contido no buffer_leitura em $a3
	sw $a3, 0($a2)		# armazena o valor do buffer (endereço tá em $a1) para o endereço de memoria_text
	
	la $s0, endereco_texto # carrega o endereço da variável endereco_texto
	addi $t1, $a2, 4	# incrementa 4 bytes no endereço de memoria
	sw $t1, 0($s0)		# armazena o novo valor do endereco_texto
## DO-WHILE:
	bgtz $v0, leituraArquivo # se o número de caracteres lidos for maior que 0, continua a leitura do arquivo
	
fechaArquivo:
	li $v0, 16
	syscall
	
## Carrega em PC o endereço inicial de memoria_text
	la $a0, PC ## carrega endereço texto
	li $a1, 0x1001008c	## carrega o valor do endereço inicial de memoria_text pra $a1
	sw $a1, 0($a0)		## armazena em PC o valor de $a1
	
## busca_instrucao: seta os valores de PC e IR para serem executados
buscaInstrucao:
	la $a0, PC	## carrega endereço de PC em $a0	
	lw $a1, 0($a0)	## carrega o valor de PC em $a1
	lw $a2, 0($a1)	## carrega o valor armazenado no endereço de PC
	
	la $a3, IR	## carrega o endereço de IR em $a3
	sw $a2, 0($a3)	## armazena a instrução na variável IR
	
	## Atualiza o PC para apontar para a próxima instrução
	addi $a1, $a1, 4
	sw $a1, 0($a0) ## armazena o valor incrementado em PC
	
	## bnez $a2, busca_instrucao ## loop pra testar que está percorrendo memoria_text
	
decodificaInstrucao: 
	lw $a0, IR
	srl $t0, $a0, 26 		## $t0 = campo OPCODE
	andi $t1, $a0, 0x0000003F 	## $t1 = campo FUNCT
	srl $t2, $a0, 6 		## $t2 = campo shamt
	andi $t2, $t2, 0x0000001F
	srl $t3, $a0, 11 		## $t3 = campo rd
	andi $t3, $t3, 0x0000001F
	srl $t4, $a0, 16 		## $t4 = campo rt
	andi $t4, $t4, 0x0000001F
	srl $t5, $a0, 21 		## $t5 = campo rs
	andi $t5, $t5, 0x0000001F
	sll $t6, $t5, 1

	## testa os valores de opcode e direciona para instrução tipo R/I/J
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
