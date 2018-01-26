%LAGUERRE
clc
close all
warning OFF 
clear 

%PARAMETROS INICIAIS
func_number = 2;
Ts = 0.001;
num = [1];
den = [1 -0.7 0.12];
sist = tf(num,den,Ts);

% %GERA SINAL PRBS
buffer = 10;
interac = 100;
vet = round(rand(1,buffer));

u =[];
for i = 1:interac
    u(1,i) = vet(1,buffer);
    xou = xor(vet(1,buffer),vet(1,buffer-1));
    e = not(xor(xou,vet(1,2))); % e tende a 0, ou tende a 1
        for j = buffer:-1:2
           vet(1,j) = vet(1,j-1); 
        end
     vet(1,1) = e;
end

%GERA OS DADOS DO SISTEMA PARA SER IDENTIFICADO
temp = 0:Ts:(Ts*(interac-1));
u = u';
[AMOSTRAS,t] = lsim(sist,u,temp');

%MANDA PARA O ALGORITMO GENÉTICO
[Genes,Yest,MSE,Polo,BASES] = GA(AMOSTRAS,t,func_number,Ts);
MSE

%CALCULA A FT DA ESTIMAÇÃO
M = 0;
for i = 1:func_number
    M = M + Genes(i)*BASES{i};
end
M
%PLOT DO RESULTADO
figure(2)
plot(t(1:end-func_number,:),AMOSTRAS(1:end-func_number,:),t(1:end-func_number,:),Yest(:,func_number:end-1))
legend('Amostras','estimado')
