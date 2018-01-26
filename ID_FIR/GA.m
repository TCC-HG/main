function [Genes,Yest,MSE,BASES] = GA(AMOSTRAS,temp,func_number,Ts)

    %PARÂMETROS DO MEU GA
    dim_pop = length(AMOSTRAS);   %VERIFICAR NECESSIDADE DO TAMANHO DA POPULAÇÃO
    tolerancia = 0.01;
    itmax = 100;
    taxa_cross = linspace(80,65,itmax);
    taxa_mut = linspace(5,40,itmax);
    p = 0;
    cromossomos = struct('genes',[],'fitness',[]);

    %GERA GANHOS ALEATÓRIOS 
    for i = 1:dim_pop
        cromossomos(i).genes = rand(1,func_number);
        cromossomos(i).fitness = inf;
    end

    %CHAMA O FITNESS E COM O RESULTADO TESTO O MENOR ERRO
    cromossomos_fit = Fitness(cromossomos,AMOSTRAS,func_number,temp,Ts);
    cromossomo_min = Minimo(cromossomos_fit,dim_pop);

    %CALCULA ATÉ ENCONTRAR O ERRO DESEJADO
    while ((abs(cromossomo_min(1).fitness) > tolerancia) && (p < itmax))

        p = p + 1;
        cromossomos_cross = Crossover(cromossomos_fit,dim_pop,taxa_cross(p));
        cromossomos_mut = Mut(cromossomos_cross,dim_pop,taxa_mut(p),func_number);
        cromossomos_mut(randi([1,dim_pop])) = cromossomo_min;
        cromossomos_fit = Fitness(cromossomos_mut,AMOSTRAS,func_number,temp,Ts);
        cromossomo_min = Minimo(cromossomos_fit,dim_pop);
        
        %GERA NOVA POPULAÇÃO PARA DESENVOLVER DIVERSIDADE
        for j = 1:dim_pop
            cromossomos_fit(j).genes = rand(1,func_number);  
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
    
    %VARIAVEIS QUE SERÃO RETORNADAS
    Yk = [];
    MSE = cromossomo_min(1).fitness;
    Genes = cromossomo_min(1).genes;
    BASES = cromossomo_min(1).bases;
    
    %RECALCULA O RESULTADO GERADO PARA RETORNAR AO USUÁRIO
    for j = 1:func_number        
         Yk = [Yk lsim(cromossomo_min(1).bases{j},AMOSTRAS,temp)];   %verificar se é 'u' ou 'AMOSTRAS'!!        
    end
    
     Yest = Genes * Yk';
end