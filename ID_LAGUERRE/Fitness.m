function cromossomo_fit = Fitness(cromossomo,AMOSTRAS,temp,Ts,func_number)

    dim_pop = size(cromossomo,2);
    memoria = struct('genes',{},'fitness',{},'polos',{},'bases',{});
    cromossomo_fit = struct('genes',{},'fitness',{},'polos',{},'bases',{});
    %func_number = length(func_number);
        
    for i = 1:dim_pop
        p = cromossomo(i).polos;
        Yk = [];
        
        %GERAÇÃO DAS FUNC{N}, FUNÇÕES DE LAGUERRE
        BASES{1} = tf(sqrt(1-p^2),[1 -p],Ts); %Ts = -1 pois a amostragem nao importa
        delg = tf([-p 1],[1 -p],-1);

        for n = 1:func_number
            if n >= 2
                BASES{n} = BASES{n-1}*delg; %n-ésima função
            end
            %FILTRAGEM DAS AMOSTRAS COM AS BASES DO FILTRO
            Yk = [Yk lsim(BASES{n},AMOSTRAS,temp)];       
        end
             
        for k = 1:dim_pop
            
             Yest = (cromossomo(k).genes * Yk');
             memoria(k).genes = cromossomo(k).genes;

             %AJUSTES NECESSÁRIOS PARA RETIRADA DOS ATRASOS DE FILTRAGEM
             a = (AMOSTRAS(1:end-func_number,:));
             b = Yest(:,func_number:end-1)';
             memoria(k).fitness = sum((a-b).^2)/length(AMOSTRAS);
             memoria(k).polos = p;
        end
       
        %COLOCA APENAS O MELHOR RESULTADO DO MSE PARA CADA POLO
        cromossomo_fit(i) = Minimo(memoria,dim_pop);
        cromossomo_fit(i).bases = BASES;
        
    end
end