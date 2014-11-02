function [S] = matsushita(k,src,dst_pre,dst_post,full_affine)
    S = zeros(2,3);
    G_k = 1/(sqrt(2*pi)*sqrt(k))*exp(-k^2/(2*sqrt(k)^2));
    source = cell(1);
    dest = cell(1);
    
    %T = cell(2*k+1,1);

    
        %{
        if (i <= k)
            for j=1:2*k+1
                idx = i-k-1+j;
                if (idx > 0)
                    T = rigid_affine(corn{i},flow{idx},full_affine);
                    S{i} = S{i} + conv2(T,G_k);
                end
            end  
        elseif (i >= length(vid)-k)
        %}
    source{1} = src;    
    for j=1:length(dst_pre)
        dest{1} = dst_pre{j};
        if ~isempty(dest{1})
            T = rigid_affine(source,dest,full_affine);
            S = S + conv2(T{1},G_k);
        end
    end
    for j=1:length(dst_post)
        dest{1} = dst_post{j};
        T = rigid_affine(source,dest,full_affine);
        S = S + conv2(T{1},G_k);
    end
end

