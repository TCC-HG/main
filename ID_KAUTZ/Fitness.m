function cromossomo_fit = Fitness(cromossomo,AMOSTRAS,temp,Ts,func_number)

    dim_pop = size(cromossomo,2);
    memoria = struct('genes',{},'fitness',{},'polos',{},'bases',{});
    cromossomo_fit = struct('genes',{},'fitness',{},'polos',{},'bases',{});
        
    for i = 1:dim_pop
        if (sqrt(cromossomo(i).polos(1)^2 + cromossomo(i).polos(2)^2) < 1)
            b = cromossomo(i).polos(1);
            c = cromossomo(i).polos(2);
            Yk = [];

            %GERAÇÃO DAS FUNC{N}, FUNÇÕES DE KAUTZ
            num = [-c b*(c-1) 1];
            den = [1 +b*(c-1) -c];

            BASES{1} = tf(sqrt(1-c^2)*[1 -b 0],den,Ts); % FUNÇÃO ÍMPAR
            BASES{2} = tf(sqrt((1-b^2)*(1-c^2)),den,Ts); % FUNÇÃO PAR

            delg = tf(num,den,Ts);

            for n = 1:((func_number)/2+1)
                if n >= 2
                    BASES{2*n-1} = BASES{2*(n-1)-1}*delg; %N-ÉSIMA FUNÇÃO ÍMPAR
                    BASES{2*n} = BASES{2*(n-1)}*delg; %N-ÉSIMA FUNÇÃO PAR
                end  
            end
            
            for j = 1:func_number
                %FILTRAGEM DAS AMOSTRAS COM AS BASES DO FILTRO
                Yk = [Yk lsim(BASES{j},AMOSTRAS,temp)]; %VERIFICAR ESTA CONSTRUÇÃO
            end

            for k = 1:dim_pop

                 Yest = (cromossomo(k).genes * Yk');
                 memoria(k).genes = cromossomo(k).genes;

                 %AJUSTES NECESSÁRIOS PARA RETIRADA DOS ATRASOS DE FILTRAGEM
                 a = (AMOSTRAS(1:end-func_number,:));
                 d = Yest(:,func_number:end-1)';
                 memoria(k).fitness = sum((a-d).^2)/length(AMOSTRAS);
                 memoria(k).polos = [b c]; %cromossomo(k).polos;
            end
            %COLOCA APENAS O MELHOR RESULTADO DO MSE PARA CADA POLO
            cromossomo_fit(i) = Minimo(memoria,dim_pop);
            cromossomo_fit(i).bases = BASES;
       
        else
            cromossomo_fit(i).genes = cromossomo(i).genes;
            cromossomo_fit(i).polos = cromossomo(i).polos;
            cromossomo_fit(i).fitness = 10; %VALOR ALTO PARA SER DESCARTADO, MAS QUE NÃO ZOE O FITMED        
        end
    end
end