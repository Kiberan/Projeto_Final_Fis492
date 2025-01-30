program programa
    use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, i4 => int32, idp => int64
    use, intrinsic :: iso_fortran_env, only: stdout => output_unit, stdin => input_unit, stderr => error_unit
    use cargas_modulo
    implicit none
    integer(sp) :: contagem,x,y,z !Variáveis auxiliares inteiras
    integer(sp) :: arquivo            !Variável para escrita do arquivo dat                !Variáveis auxiliares e elementos das coordenadas do vetor_posicao
    real(dp) :: t = 0.00              !Tempo comum
    real(dp) :: i = 0                 !Variável auxiliar real          
    real(dp) :: tempo_total = 10      !Tempo total de simulação
    real(dp) :: numero_de_imagens = 600     !Número de imagens para fazer o GIF
    real(dp) :: tempo_medio = 0.00


    real(dp), dimension(3) :: campo, vetor_posicao !Vetores campo para o campo elétrico e vetor_posicao
                                                   !para indicar um ponto do espaço no qual estará o vetor
    real(dp), dimension(125,3) :: vetores_posicaoR !Lista de vetores posição
    type(carga) :: particula1          !Cria-se a partícula com propriedades elétricas 
    particula1%posicao_inicial = [0,0,0] !Define sua posição inicial
    particula1%velocidade = [1,0,0]      !Define seu vetor velocidade
    open(newunit=arquivo , file = 'Dados_Do_Campo_Elétrico.dat') !Cria-se o arquivo de dados
    write(arquivo, '(A18, A26, A26, A26, A26, A26, A26)') "Coordenada_X(m)", "Coordenada_Y(m)", "Coordenada_Z(m)", "Tempo(s)" &
    , "Coordenada_U(m)", "Coordenada_V(m)", "Coordenada_W(m)"
    !Escreve no arquivo dat os nomes das colunas

    vetores_posicaoR (:,:) = 0
    numero_de_imagens = 600.00
    x = 0
    y = 0
    z = 0
    contagem = 1
    !--------------------------- Loopzim para criar os pontos de interesse no espaço --------------------
    !Há alguma maneira melhor de fazer isso?
    do x = 1, 5
        do y = 1, 5
            do z = 1, 5
                vetores_posicaoR(contagem,1) = real(x,dp) !Podemos inserir constantes como 1E-10 para aproximar
                vetores_posicaoR(contagem,2) = real(y,dp) !da carga e possivelmente obter melhores valores
                vetores_posicaoR(contagem,3) = real(z,dp) !Mas tem que alterar a norma e espaçamento no Python
                contagem = contagem +1
            end do
        end do
    end do
    !------------------------------------------------------------------------------------------------------
    !------------------------CALCULA O CAMPO EM CADA VETOR E ESCREVE ARQUIVO DAT---------------------------
    
do while (i<= numero_de_imagens)
    contagem =1
    do while (contagem<=125) !
        vetor_posicao = [vetores_posicaoR(contagem,1),vetores_posicaoR(contagem,2),vetores_posicaoR(contagem,3)]
        campo = Campo_Eletrico(t, vetor_posicao,particula1)
        write(arquivo,*) campo(1), campo(2), campo(3), t, vetores_posicaoR(contagem,1), vetores_posicaoR(contagem,2)&
        , vetores_posicaoR(contagem,3)
        !Delta_t = T_f - T_i / numero de imagens
        contagem = contagem +1
    end do
    i = i+1
    t =(tempo_total/numero_de_imagens)*i !Tempo t atualizado fora do loop de escrita, logo o arquivo ocntem somente o próprio t
end do
    close(arquivo)
    !Escrever para cada instante de tempo t qual sera o vetor campo eletrico em cada um dos 125 vetores
    !Para inicio talvez 10 segundos seria lega, em 10 segundos 200 imagens são poucas o que dá 20FPS
    !Passemos para 60FPS o que da 60 imagens por segundo
end program
