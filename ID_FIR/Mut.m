function cromossomos_mut = Mut (cromossomos_fit,dim_pop,taxa_mut,func_number)
    
    cromossomos_mut = struct('genes',[],'fitness',[],'bases',{});
   %taxa_mut=10;
    
    for i = 1:dim_pop
        
        if randi([1,100]) < taxa_mut 
        
              n = randi([1,25]);
             cromossomos_mut(i).genes = cromossomos_fit(i).genes;
             for z = 1:n
                cromossomos_mut(z).genes(1,randi([1,func_number])) = rand*10;
             end           
        else 
           cromossomos_mut(i).genes = cromossomos_fit(i).genes;
           cromossomos_mut(i).bases = cromossomos_fit(i).bases;
        end
    end
end   