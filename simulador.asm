# Projeto: Simulador do processador MIPS
# Arquivo: simulador.asm
# Descrição:
# Autores: Maria Rita Piekas e Nathália Zófoli
# data da criação: 09/04/2024

.text
## busca_instrucao: seta os valores de PC e IR para serem executados
busca_instrucao:
	la $t0, PC     		## carrega endereço de PC para $t0
	lw $s0, 0($t0) 		##  carrega o valor de PC para $s0
	sw $s0, IR     		## armazena no IR o valor de PC
	addi $t0, $s0, 4 	## soma 4 ao endereço de PC
	sw $t0, PC		## armazena o resultado em PC
	
	


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

