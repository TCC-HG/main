function [m_ufc] = Torneio (cromossomos_fit,dim_pop)

    minimo_ufc = inf;
    
    for i = 1:dim_pop
        
        k = randi([1,dim_pop]);
        
        if abs(cromossomos_fit(k).fitness) < abs(minimo_ufc)
            minimo_ufc = cromossomos_fit(k).fitness;
            m_ufc = k;
        else
            m_ufc = i;
        end 
    end
end