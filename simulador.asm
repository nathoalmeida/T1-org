# Projeto: Simulador do processador MIPS
# Arquivo: simulador.asm
# Descrição:
# Autores: Maria Rita Piekas e Nathália Zófoli
# data da criação: 09/04/2024

.text
##############################################
leituraArquivo:
##############################################
	li $v0, 13 		# descritor para a abertura de arquivo com syscall
	la $a0, local_arquivo 	# carrega o nome do arquivo em $a0
	li $a1, 0 		# 0 = abre o arquivo em modo de leitura
	syscall

	move $s0, $v0 		## copia o descritor do arquivo de $v0 para $s0
	
	move $a0, $s0
	li $v0, 14 		# descritor para a leitura do arquivo
	la $a1, memoria_text 	# armazena o conteúdo na nossa memória
	li $a2, 1024 		# valor do espaço em memoria_text
	syscall
	
	li $v0, 4
	move $a0, $a1
	syscall
	
	li $v0, 16
	move $a0, $s0
	syscall
	
	
# instruções
# carregar arquivo binário na memória
# enquanto não terminaram as instruções
# (1) ler uma instrução
# (2) decodificar a instrução 
# (3) executar
# terminar o programa

.data
# dados do simulador
# variável memória ou variáveis
# segmento de código
# segmento de dados
# segmentos da pilha
# registradores
# campos da instrução
	PC: .word 0
	IR: .word 0
	regs: .space 128
	memoria_text: .space 1024
	memoria_data: .space 1024
	memoria_pilha: .space 1024
	endereco_texto: .word 0x0040000000
	endereco_data: .word 0x10010000
	endereco_pilha: .word 0x7FFFEFFC
	local_arquivo: .asciiz "trabalho_01-2024_1.bin"


