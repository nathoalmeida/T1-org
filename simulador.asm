# Projeto: Simulador do processador MIPS
# Arquivo: simulador.asm
# Descrição:
# Autores: Maria Rita Piekas e Nathália Zófoli
# data da criação: 09/04/2024
.text

main:
	jal 	aberturaArquivo
	jal 	leituraArquivo
	jal 	fechaArquivo
	jal 	aberturaArquivoData
	jal 	leituraArquivo
	jal 	fechaArquivo
	jal 	inicioBuscaInstrucao
	loop_main:
	jal	buscaInstrucao
	jal	decodificaInstrucao
	jal 	executaInstrucao
	j loop_main
##############################################
aberturaArquivo:
	la $a0, local_arquivo 	  	# carrega o endereço do arquivo em $a0
	li $a1, 0 		  	# seta a flag do arquivo em 0 para modo de leitura
	la $a0, local_arquivo 	  	# carrega o nome do arquivo em $a0
	li $v0, 13 		  	# 0 = abre o arquivo em modo de leitura
	syscall			  	# faz a chamada de sistema n. 13 para abrir o arquivo
	la $t0, descritor_arquivo 	# armazena em $t0 o endereço do descritor do arquivo
	sw $v0, 0($t0)		  	# armazena em descritor_arquivo o valor de retorno da chamada	
	## Testa a abertura do arquivo:
	add $t1, $zero, $t0	 	# armazena em $t1 o valor de retorno da chamada 
	bltz $t1, encerraPrograma 	# se o retorno da chamada for negativo, houve erro na abertura do arquivo
	
	lw $a0, 0($t0)			# armazena o valor do descritor do arquivo em $a0 
	jr	$ra
	
aberturaArquivoData:
	la $a0, local_arquivo_data 	  # carrega o endereço do arquivo em $a0
	li $a1, 0 		  	  # seta a flag do arquivo em 0 para modo de leitura
	la $a0, local_arquivo_data 	  # carrega o nome do arquivo em $a0
	li $v0, 13 		  	  # 0 = abre o arquivo em modo de leitura
	syscall			  	  # faz a chamada de sistema n. 13 para abrir o arquivo
	la $t0, descritor_arquivo 	  # armazena em $t0 o endereço do descritor do arquivo
	sw $v0, 0($t0)		  	  # armazena em descritor_arquivo o valor de retorno da chamada	
	## Testa a abertura do arquivo:
	add $t1, $zero, $t0	 	  # armazena em $t1 o valor de retorno da chamada 
	bltz $t1, encerraPrograma	  # se o retorno da chamada for negativo, houve erro na abertura do arquivo
	
	lw $a0, 0($t0)			  # armazena o valor do descritor do arquivo em $a0 
	jr	$ra
	
leituraArquivo:	
	la $a1, buffer_leitura  	# carrega em $a1 o endereço da variável buffer_leitura
	li $a2, 4			# carrega em $a2 o número de bytes que serão lidos do arquivo
	li $v0, 14			# carrega em $v0 a chamada que será feita ao sistema (14 = leitura arquivo)
	syscall
	
## Armazena o valor de buffer_leitura para memoria_text e incrementa o endereço de memoria_text
	lw $a2, endereco_texto		# carrega o endereço inicial de memoria_texto em $a2
	lw $a3, 0($a1) 			# carrega o valor contido no buffer_leitura em $a3
	sw $a3, 0($a2)			# armazena o valor do buffer (endereço tá em $a1) para o endereço de memoria_text
	
	la $s0, endereco_texto 		# carrega o endereço da variável endereco_texto
	addi $t1, $a2, 4		# incrementa 4 bytes no endereço de memoria
	sw $t1, 0($s0)			# armazena o novo valor do endereco_texto
## DO-WHILE:
	bgtz $v0, leituraArquivo 	# se o número de caracteres lidos for maior que 0, continua a leitura do arquivo
	jr	$ra
	
fechaArquivo:
	li $v0, 16
	syscall
	jr	$ra

inicioBuscaInstrucao:	
## Carrega em PC o endereço inicial de memoria_text
	la $a0, PC 			## carrega endereço texto
	la $a1, endereco_texto		## carrega o valor do endereço inicial de memoria_text pra $a1
	sw $a1, 0($a0)			## armazena em PC o valor de $a1
	jr	$ra
	
## busca_instrucao: seta os valores de PC e IR para serem executados
buscaInstrucao:
	la $a0, PC			## carrega endereço de PC em $a0	
	lw $a1, 0($a0)			## carrega o valor de PC em $a1
	lw $a2, 0($a1)			## carrega o valor armazenado no endereço de PC
	
	la $a3, IR			## carrega o endereço de IR em $a3
	sw $a2, 0($a3)			## armazena a instrução na variável IR
	
	## Atualiza o PC para apontar para a próxima instrução
	addi $a1, $a1, 4
	sw $a1, 0($a0) 			## armazena o valor incrementado em PC

	jr	$ra
	
############################################################################################################################	
 # Mapa Campos da Instrução - Decodifica Instrução
 # INSTRUÇÕES R
 # $s0 = campo OPCODE
 # $s1 = campo funct
 # $s2 = campo shamt
 # $s3 = campo rd
 # $s4 = campo rt
 # $s5 = campo rs
 
 # INSTRUÇÕES I
 # $s0 = campo OPCODE
 # $s1 = campo Immediate
 # $s4 = campo rt
 # $s5 = campo rs

 # INSTRUÇÕES J
 # $s0 = campo OPCODE
 # $s1 = campo Address

decodificaInstrucao: 
# ideia addi	$sp, $sp, -4
# ideia sw	$ra, 0($sp)
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
	## DIRECIONA PRO TIPO DE INSTRUÇÃO
	beqz    $s0,    instrucaoR		# if opcode == 0 instrucao do tipo r
	bge 	$s0, 4, instrucaoI		# else if opcode >= 4 instrucao do tipo i
	j       instrucaoJ			# else instrucao do tipo j
	
# ideia lw	$ra, 0($sp)
# ideia addi	$sp, $sp, 4
	
instrucaoR:
	jr	$ra
	
instrucaoI:
	sll $t0, $s3, 11 ## desloca campo rd 11 bits para esquerda
	sll $t1, $s2, 6 ## desloca campo shamt 6 bits para esquerda
	add $t2, $t1, $t0 ## soma shamt+rd
	add $t2, $t2, $s1 ## soma shamt+rd+funct
	sw $t2, 0($s1) 	  ## $s1 -> immediate
	jr	$ra

instrucaoJ:
	sll $t0, $s5, 21  ## desloca campo rs 16 bits para esquerda
	sll $t1, $s4, 16  ## desloca campo rt 16 bits para esquerda
	sll $t2, $s3, 11  ## desloca campo rd 11 bits para esquerda
	sll $t3, $s2, 6   ## desloca campo shamt 6 bits para esquerda
	add $t4, $t0, $t1 ## $t4 -> rs+rt
	add $t5, $t2, $t3 ## $t5 -> rd+shamt
	add $t4, $t4, $t5 ## $t4 + $t5
	sw  $t4, 0($s1)   ## $s1 -> address
	jr	$ra	 

executaInstrucao:
## add
instADD: 
#rd = rs + rt
        ## rs
	la $t0, regs      ## endereço inicial dos registradores
	sll $t1, $s5, 2   ## 4 * n. do registrador rs
	add $t1, $t1, $t0 ## endereço inicial de regs + 4 * n. do registrador
	lw $t2, 0($t1)    ## $t2 = valor armazenado em regs[rs]
	## rt
	sll $t1, $s4, 2   ## 4 * n. do registrador rt
	add $t1, $t1, $t0 ## endereço inicial de regs + 4 * n. do registrador
	lw $t3, 0($t1)    ## $t3 = valor armazenado em regs[rt]
	## rd
	sll $t1, $s3, 2   ## 4 * n. do registrador de destino (rd)
	add $t1, $t1, $t0 ## $t1 -> endereço do registrador rd
	add $t4, $t3, $t2 ## $t4 = rs+rt
	sw  $t4, 0($t1)
	jr	$ra
	
## addu	
instADDU:
#rd = rs + rt (sem sinal)
        ## rs
	la $t0, regs      ## endereço inicial dos registradores
	sll $t1, $s5, 2   ## 4 * n. do registrador rs
	add $t1, $t1, $t0 ## endereço inicial de regs + 4 * n. do registrador
	lw $t2, 0($t1)    ## $t2 = valor armazenado em regs[rs]
	## rt
	sll $t1, $s4, 2   ## 4 * n. do registrador rt
	add $t1, $t1, $t0 ## endereço inicial de regs + 4 * n. do registrador
	lw $t3, 0($t1)    ## $t3 = valor armazenado em regs[rt]
	## rd
	sll $t1, $s3, 2   ## 4 * n. do registrador de destino (rd)
	add $t1, $t1, $t0 ## $t1 -> endereço do registrador rd
	add $t4, $t3, $t2 ## $t4 = rs+rt
	sw  $t4, 0($t1)
	jr	$ra

## addiu	
instADDIU:
	la $t0, regs      ## endereço inicial dos registradores
	lw $t1, 0($s1)	  ## valor Imm armazenado
	sll $t2, $s5, 2	  ## 4 * valor armazenado em rs
	add $t3, $t2, $t0 ## endereço do registrador rs
	lw $t2, 0($t3)    ## $t2 -> valor armazenado em rs
	add $t2, $t2, $t1 ## rs+imm
	## rt
	sll $t1, $s4, 2	  ## 4 * valor armazenado em rt
	add $t3, $t1, $t0 ## $t3 -> endereço do registrador rt
	sw $t2, 0($t3)    ## registrador rt = rs +imm 
	jr	$ra
	
## addi	
instADDI:
	la $t0, regs      ## endereço inicial dos registradores
	lw $t1, 0($s1)	  ## valor Imm armazenado
	sll $t2, $s5, 2	  ## 4 * valor armazenado em rs
	add $t3, $t2, $t0 ## endereço do registrador rs
	lw $t2, 0($t3)    ## $t2 -> valor armazenado em rs
	add $t2, $t2, $t1 ## rs+imm
	## rt
	sll $t1, $s4, 2	  ## 4 * valor armazenado em rt
	add $t3, $t1, $t0 ## $t3 -> endereço do registrador rt
	sw $t2, 0($t3)    ## registrador rt = rs +imm 
	jr	$ra
	
## sw
instSW:
	la  $t0, regs      ## endereço inicial dos registradores
	sll $t1, $s4, 2	   ## $t1 -> valor do campo rt * 4
	add $t1, $t1, $t0  ## $t1 -> endereço efetivo do registrador rt
	sll $t2, $s5, 2    ## $t2 -> valor do campo rs * 4
	add $t2, $t2, $t0  ## $t2 -> endereço efetivo do registrador rs
	lw  $t3, 0($s1)    ## $t3 -> valor do campo immediate
	add $t3, $t3, $t2  ## $t3 -> imm + rs
	lw  $t0, 0($t1)
	sw  $t0, 0($t3)    ## armazena o valor de rt no endereço imm + rs
	jr	$ra
	
## lw
instLW:
	la $t0, regs 
	sll $t1, $s4, 2	   ## $t1 -> valor do campo rt * 4
	add $t1, $t1, $t0  ## $t1 -> endereço efetivo do registrador rt
	sll $t2, $s5, 2    ## $t2 -> valor do campo rs * 4
	add $t2, $t2, $t0  ## $t2 -> endereço efetivo do registrador rs
	lw  $t3, 0($s1)    ## $t3 -> valor do campo immediate
	add $t3, $t3, $t2  ## $t3 -> imm + rs
	lw  $t1, 0($t3)
	jr	$ra

instLA:
	la $t0, regs       ## endereço inicial dos registradores
    	sll $t1, $s5, 2    ## $t1 -> valor do campo rt * 4
    	add $t2, $t1, $t0  # $t2 -> Endereço base + rt 
    	sll $t1, $s4, 2    ## $t1 -> valor do campo rs * 4
    	add $t1, $t1, $t0  ## Endereço base + rs
    	sw $t1, 0($t2)     # Armazena endereço em $t2
    	jr	$ra
    	
instMOVE:
	la $t0, regs
    	sll $t1, $s5, 2    ## $t1 -> valor do campo rt * 4
    	add $t1, $t1, $t0  ## Calcula o endereço do rt
    	lw $t5, 0($t1)     ## $t5 -> Carrega o valor do rt $t5
    	sll $t3, $s4, 2    ## $t3 -> valor do campo rs * 4
    	add $t3, $t3, $t0  ## Endereço base + rs
    	sw $t5, 0($t3)     ## Armazena o valor de rt em rs
    	jr	$ra

instBNE:
	la  $t0, regs
	sll $t1, $s5, 2      ## $t1 -> valor do campo rt * 4
    	add $t1, $t1, $t0    ## Calcula o endereço do rt
    	lw  $t5, 0($t1)      ## $t5 -> Carrega o valor do rt $t5
    	sll $t3, $s4, 2      ## $t3 -> valor do campo rs * 4
    	add $t3, $t3, $t0    ## Calcula o endereço do rs
    	lw  $t4, 0($t3)      ## $t4 -> Carrega o valor do rs
    	
    	beq $t4, $t3, fimBNE ## se valores forem iguais, encerra a instrução e retorna pra main
   
   	lw $t0, PC	     ## $t0 -> valor de PC
   	lw $t1, 0($s1)       ## $t1 -> valor do immediate
   	sll $t1, $t1, 2	     ## Imm * 4 -> deslocamento de 4 bytes
   	add $t2, $t0, $t1    ## $t2 -> PC + n. de instruções a serem deslocadas
   	sw $t2, PC	
    	
fimBNE:
	jr	$ra
	
instMUL:
	la  $t0, regs
	sll $t1, $s5, 2      ## $t1 -> valor do campo rt * 4
    	add $t1, $t1, $t0    ## Calcula o endereço do rt
    	lw  $t5, 0($t1)      ## $t5 -> Carrega o valor do rt $t5
    	sll $t3, $s4, 2      ## $t3 -> valor do campo rs * 4
    	add $t3, $t3, $t0    ## Calcula o endereço do rs
    	lw  $t4, 0($t3)      ## $t4 -> Carrega o valor do rs 
    	
    	sll $t1, $s3, 2      ## $t1 -> valor do campo rd * 4
    	add $t1, $t1, $t0    ## Calcula o endereço do rd
    	mul $t2, $t4, $t5    ## $t2 -> multiplicação de rs+rt
    	sw $t2, 0($t1)       ## armazena o resultado em RD
    	
    	mfhi 	$t0	     # $t0 -> valor de hi
    	la	$t1, HI	     
    	sw	$t0, 0($t1)  # Insere $t0 no endereço de hi 
    	mflo 	$t2	     # $t2 -> valor de lo
    	la	$t3, LO	     
    	sw	$t2, 0($t3)  # Insere $t2 no endereço de lo
    	
    	jr	$ra
	

##############################################
encerraPrograma:
	li $v0, 17
	syscall			# faz a chamada 17 e encerra o programa	


.data
	PC: 			.word 0
	IR: 			.word 0
	HI:			.word 0
	LO:			.word 0
	regs: 			.space 128 	  ## Registradores do simulador
	buffer_leitura: 	.space 4  ## Buffer para leitura do arquivo de entrada. Armazena 4 bytes por vez
	memoria_text: 		.space 1024
	memoria_data: 		.space 1024
	memoria_pilha:		.space 1024
	endereco_texto: 	.word 0x1001008c
	endereco_data:  	.word 0x10010000
	endereco_pilha:		.word 0x7FFFEFFC
	local_arquivo:  	.asciiz "/home/nathizofoli/Documentos/workspace/T1-org/trabalho_01-2024_1.bin"
	local_arquivo_data: 	.asciiz ""
	descritor_arquivo: 	.word 0
	