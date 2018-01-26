function cromossomos_cross = Crossover (cromossomos_fit,dim_pop,taxa_cross)
    
    cromossomos_cross = struct('genes',[],'fitness',[],'bases',{});
    %taxa_cross=60;
    
    for i = 1:dim_pop
        
        if randi([1,100]) < taxa_cross 
        
            pai = Torneio(cromossomos_fit,dim_pop);
            
            for j = 1:size(cromossomos_fit(i).genes,2)
                
                if rand > 0.5
                    cromossomos_cross(i).genes(1,j) = cromossomos_fit(pai).genes(1,j);
                
                else
                    cromossomos_cross(i).genes(1,j) = cromossomos_fit(i).genes(1,j);
                end
            end 
        else 
             cromossomos_cross(i).genes = cromossomos_fit(i).genes;
             cromossomos_cross(i).bases = cromossomos_fit(i).bases;
        end
    end
end   