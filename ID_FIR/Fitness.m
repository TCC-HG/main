function [cromossomo_fit] = Fitness(cromossomo,AMOSTRAS,func_number,temp,Ts)

    dim_pop = size(cromossomo,2);
    cromossomo_fit = struct('genes',{},'fitness',{},'bases',{});
    Yk = [];
    num_base = [1];
    den_base = [1 0];    
    delg = tf(num_base,den_base,Ts);
    BASES{1} = delg;
    
    % GERA BASES 
    for n = 1:func_number
        if n >= 2
                BASES{n} = BASES{n-1}*delg; %n-ésima função
        end
        %FILTRAGEM DAS AMOSTRAS COM AS BASES DO FILTRO
        Yk = [Yk lsim(BASES{n},AMOSTRAS,temp)];
    end

    for i = 1:dim_pop
        
         Yest = (cromossomo(i).genes * Yk');
         cromossomo_fit(i).genes = cromossomo(i).genes;
         
         %AJUSTES NECESSÁRIOS PARA RETIRADA DOS ATRASOS DE FILTRAGEM
         a = (AMOSTRAS(1:end-func_number,:));
         b = Yest(:,func_number:end-1)';
         cromossomo_fit(i).fitness = sum((a-b).^2)/length(AMOSTRAS);
         cromossomo_fit(i).bases = BASES;
    end         
end