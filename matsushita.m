function [S] = matsushita(k,T_prev,T_post)
    S = zeros(3,3);
    G_k = 1/(sqrt(2*pi)*sqrt(k))*exp(-k^2/(2*sqrt(k)^2));
  
    for j=1:length(T_prev)
        S = S + conv2(T_prev{j},G_k);
    end
    for j=1:length(T_post)
        S = S + conv2(T_post{j},G_k);
    end
end

