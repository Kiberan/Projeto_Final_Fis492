module cargas_modulo
    use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, i4 => int32, idp => int64
    use, intrinsic :: iso_fortran_env, only: stdout => output_unit, stdin => input_unit, stderr => error_unit
    implicit none
    private
    real(dp) :: t_ret
    public :: carga, t_ret, escreve_dados, Campo_Eletrico !Assim permito que crie objeto carga fora desse módulo e que t_ret possa ser
    !externalizado
    real(dp) , parameter :: TOL = 0.0000000001
    type carga  !Criando objeto do tipo carga
        real(dp) :: valor
        real(dp), dimension(3) :: posicao_inicial
        real(dp), dimension(3) :: velocidade
    end type

contains 
            !As funções envolvendo objetos devem estar no módulo desse objeto
            !t_ret deve ser encontrado através da equação: t_ret = t - (1/c)*|R - r(t_ret)|
            !Para encontrar a solução dessa equação para t_ret optamos por usar o método da bijeção
            !Os vetores posição inicial e velocidade devem ser definidos anteriormente

!------Função que diz onde a particula se encontra ------------------------------------------------
    function trajetoria(particula, t) result(posicao_atual)
        type(carga) :: particula
        real(dp) :: t
        real(dp), dimension(3) :: posicao_atual
        if (t>= 0) posicao_atual = particula%velocidade * t + particula%posicao_inicial   
    end function
!------Função para cálculo do módulo de um vetor genérico em precisão dupla------------------------
    function calcula_modulo(v) result(res)
        real(dp), dimension(3) :: v
        real(dp) :: res
        res= sqrt(sum(v**2))
    end function
!------Função para normalizar um vetor
    function normaliza_vetor(v) result(res)
        real(dp), dimension(3) :: v,res
        res = v*(1/calcula_modulo(v))
    end function
!------Função que gera a equação a ser resolvida para encontrar t_ret------------------------------
    function g(t,tempo_ret, vetor_posicao,particula) result(equacao)!Queria organizar de uma forma
            type(carga) :: particula                                !que não precise usar o objeto particula
            real(dp) :: t, tempo_ret,equacao,c
            real(dp), dimension(3) :: vetor_posicao
            c = 299792458
            equacao = t - tempo_ret + (1/c)* calcula_modulo(vetor_posicao - trajetoria(particula,tempo_ret))
    end function
!Para fazer de maneira que não precise chamar o objeto particula é necessário imbutir tudo
!------Método da Biseção para achar t_ret a partir da equação feita acima---------------------------
    function solve(tmin,tmax,tempo_ret,vetor_posicao,particula) result(bisecao)
        real(dp) :: gmin,gmax,tmin,tmax,tempo_ret, bisecao, calc
        real(dp), dimension(3) :: vetor_posicao
        type(carga) :: particula
        gmin = g(tmin, tempo_ret, vetor_posicao,particula)
        gmax = g(tmax,tempo_ret, vetor_posicao,particula)
            do while  (ABS(tmax - tmin) > TOL)
                calc = (tmin + tmax)/2
                if (g(calc,tempo_ret,vetor_posicao,particula) *gmin > 0) then
                    tmin = calc
                else
                    tmax = calc
                end if
            end do
        bisecao = (tmin +tmax) /2 !Retorna um valor aproximado do zero
    end function
!O tempo t_ret fica então tomado como 
    ! t_ret = solve(t - 2* calcula_modulo(vetor_posicao)/c , t, t,vetor_posicao, particula)

!------Juntando todas as peças que criamos até agora podemos escrever a expressão para o campo elétrico
    function Campo_Eletrico(t, vetor_posicao,particula) result(E)
        real(dp):: t,t_ret
        real(dp), dimension(3) :: vetor_posicao, r_ret, u_ret, E
        type(carga) :: particula
        real(dp) , parameter :: c = 299792458
        real(dp), parameter :: KQ = 1000
        t_ret = solve(t -(2/c)*calcula_modulo(vetor_posicao),t,t,vetor_posicao,particula)
        r_ret = vetor_posicao - particula%velocidade*t_ret
        u_ret = c*normaliza_vetor(r_ret) - t_ret * particula%velocidade
        E = KQ*calcula_modulo(r_ret)*((DOT_PRODUCT(r_ret,u_ret))**(-3)) &
        / (c**2 - (t_ret)*sqrt(DOT_PRODUCT(particula%velocidade, particula%velocidade)))
    end function
    !E(t,R,particula)
    !Agora precisamos calcular para uma lista de vetores posição definidas (para facilitar visualização no plot)
    !E então calcular para cada tempo t de um t = t_0 a t= t_f. Pensando por volta de 10 segundos
    !Escrever isso em um arquivo .dat e passar para plotar em Python via matplotlib
!------Subrotina para escrever o arquivo de dados
    subroutine escreve_dados(arquivo,campo_eletrico,tempo)!Apenas para escrever
        integer(sp) :: arquivo
        real(dp), dimension(3) :: campo_eletrico
        real(dp) :: tempo
        write(arquivo, '(A20, A20, A20, A20)') "Coordenada X(m)", "Coordenada Y(m)", "Coordenada Z(m)", "Tempo(s)"
        write(arquivo,*) campo_eletrico(1), campo_eletrico(2), campo_eletrico(3), tempo
    end subroutine

  
end module