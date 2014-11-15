function [S] = matsushita(k,T_prev,T_post)
   
    T = cell(2*k+1,1);
    T(1:k,1) = T_prev(1:k,1);
    T{k+1,1} = [1 0 0;0 1 0;0 0 1];
    T(k+2:end,1) = T_post(1:k,1);
    for i=1:length(T);
        if(isempty(T{i}))
            T{i} = [1 0 0;0 1 0;0 0 1];
        end
    end
    
    
    n=1:4*k+1;
    dev=sqrt(k);
    G_k = 1/(sqrt(2*pi)*dev)*exp(-(n-(2*k+1)).^2/(2*dev^2));
    
    S = zeros(3,3);
    for i=1:3
        for j=1:3
            param = get_vector(T,i,j)';
            out = conv(param,G_k,'same');
            S(i,j) = sum(out);
        end
    end
    S = S./S(3,3);
    
end

