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


## mapa dos registradores ##
## endereço inicial: 0x10010008


