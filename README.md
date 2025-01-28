# Projeto_Final_Fis492
Arquivos requisitados para a entrega do projeto final da disciplina FIS492 no semestre de 2024/2.
--------------------------------------------------------------------------------------------------
#Autores: Murilo Garcia, Maria Eduarda
--------------------------------------------------------------------------------------------------

# UTILIZAÇÃO DO PROGRAMA #
O programa consiste de dois três arquivos:
  1 - cargas_modulo.f90
  2 - programa.f90
  3-  plot.py

# ETAPA 1
  O usuário deve alterar as condições iniciais conforme desejar modificando o objeto particula1
em particula1%posicao_inicial e particula1%velocidade. Caso deseja pode alterar o tempo de simu
lação em tempo_total e em numero_de_imagens adaptando assim o FPS médio que desejar.
# ETAPA 2
Feito isso basta compilar cargas_modulo.f90 e programa.f90. Ao rodar o arquivo .out irá gerar
um arquivo .dat com nome Dados_Do_Campo_Elétrico.
# ETAPA 3
A última etapa agora consiste em executar o arquiv plot.py que irá usar o arquivo dat para
plotar os vetores campo elétrico e magnético gerando uma imagem para cada instante de tempo
mediante ao previamente selecionado via numero_de_imagens e tempo_total.
