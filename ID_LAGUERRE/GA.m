function [Genes, Yest,MSE,Polo,BASES] = GA(AMOSTRAS,temp,func_number,Ts)

    %PARÂMETROS DO MEU GA
    dim_pop = length(AMOSTRAS);   %VERIFICAR NECESSIDADE DO TAMANHO DA POPULAÇÃO
    tolerancia = 0.001;
    itmax = 100;
    taxa_cross = linspace(80,65,itmax);
    taxa_mut = linspace(5,40,itmax);
    p = 0;
    cromossomos = struct('genes',[],'fitness',[],'polos',[]);

    %GERA GANHOS ALEATÓRIOS 
    for i = 1:dim_pop
        cromossomos(i).genes = rand(1,func_number);
        cromossomos(i).fitness = inf;
        cromossomos(i).polos = rand(1,1);
    end

    %CHAMA O FITNESS E COM O RESULTADO TESTO O MENOR ERRO
    cromossomos_fit = Fitness(cromossomos,AMOSTRAS,temp,Ts,func_number);
    cromossomo_min = Minimo(cromossomos_fit,dim_pop);
    
    %CALCULA ATÉ ENCONTRAR O ERRO DESEJADO
    while ((abs(cromossomo_min(1).fitness) > tolerancia) && (p < itmax))

        p = p + 1;
        cromossomos_cross = Crossover(cromossomos_fit,dim_pop,taxa_cross(p));
        cromossomos_mut = Mut(cromossomos_cross,dim_pop,taxa_mut(p),func_number);
        cromossomos_mut(randi([1,dim_pop])) = cromossomo_min(1);
        cromossomos_fit = Fitness(cromossomos_mut,AMOSTRAS,temp,Ts,func_number);
        cromossomo_min = Minimo(cromossomos_fit,dim_pop);
                
        %GERA NOVA POPULAÇÃO PARA DESENVOLVER DIVERSIDADE
        for j = 1:dim_pop
            cromossomos_fit(j).genes = rand(1,func_number);
            cromossomos_fit(j).polos = rand(1,1);
        end   
        
        %PLOTA O DESENVOLVIMENTO DO FITNEES
        total = 0;
        for j = 1:dim_pop
            total = total + cromossomos_fit(j).fitness; 
        end

        Fit_min(p)= cromossomo_min(1).fitness;
        Fit_med(p)= total/dim_pop;
        geracao(p)= p;

        figure(1)
        subplot(2,1,1)
        plot(geracao,Fit_med,'b',geracao,Fit_min,'r')
        grid on;
        subplot(2,1,2)
        plot(geracao,Fit_min,'r')
        grid on;
        pause(0.000001);
    end
    
    %DEFINE VARIAVEIS QUE SERÃO RETORNADAS
    Yk = [];
    MSE = cromossomo_min(1).fitness;
    Genes = cromossomo_min(1).genes;    
    Polo = cromossomo_min(1).polos;
    BASES = cromossomo_min(1).bases;
    
    for j = 1:func_number           
         Yk = [Yk lsim(cromossomo_min(1).bases{j},AMOSTRAS,temp)];   %verificar se é 'u' ou 'AMOSTRAS'!!        
    end
    
    %RECALCULA O RESULTADO GERADO PARA RETORNAR AO USUÁRIO
    Yest = Genes * Yk';
end