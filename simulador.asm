# Projeto: Simulador do processador MIPS
# Arquivo: simulador.asm
# Descrição:
# Autores: Maria Rita Piekas Nathália Zófoli
# data da criação: 09/04/2024

.text
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

