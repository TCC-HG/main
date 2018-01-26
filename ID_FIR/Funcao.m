function [valor] = Funcao(cromossomos = struct('genes',[],'fitness',[]), dim_pop)

for i=1:dim_pop
    valor(i) = cromossomos(i).genes(1,1)^2+cromossomos(i).genes(1,2)^2+cromossomos(i).genes(1,3)^2
    if valor(i)<cromossomos(i).fitness
        cromossomos(i).fitness = valor(i)
        
    end
end

end