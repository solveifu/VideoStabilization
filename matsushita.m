function [S] = matsushita(k,T_prev,T_post)
    S = zeros(3,3);
    t=1:k;
    G_k = 1/(sqrt(2*pi)*sqrt(k))*exp(-t.^2/(2*sqrt(k)^2));
  
    for j=1:length(T_prev)
        if(~isempty(T_prev{j}))
            S(1:2,1:3) = S(1:2,1:3) + T_prev{j}(1:2,1:3).*G_k(length(T_prev)-j+1);
        end
    end
    for j=1:length(T_post)
        if(~isempty(T_post{j}))
            S(1:2,1:3) = S(1:2,1:3) + T_post{j}(1:2,1:3).*G_k(j);
        end
    end
    S(3,:) = [0 0 1];
end

