function [cromossomo_min] = Minimo (cromossomos_fit,dim_pop)

    cromossomo_min = struct('genes',{},'fitness',{},'polos',{},'bases',{});
    minimo = inf;

    for i = 1:dim_pop
        if abs(cromossomos_fit(i).fitness) < abs(minimo)
            minimo = cromossomos_fit(i).fitness;
            cromossomo_min = cromossomos_fit(i);
        end
    end
end