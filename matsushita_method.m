function [T] = matsushita_method(T_forw,k)
    inv(T_forw{1});
    
    T_rev = cellfun(@inv,T_forw,'un',0);
    T_prev = cell(k,1);
    T_post = cell(k,1);
    T = cell(length(T_forw),1);
    l = 0;
    
    for i=1:length(T_forw)
        % The first frames, where there is less than k previous frames
        if (i <= k)
            % If later than first frame
            if ~isequal(i,1)
               T_prev(k-i+2:k,1) = prev_accum(T_rev(1:i-1));
            end
            T_post = post_accum(T_forw(i:i+k-1));
                 
        % The last frames, where there is less than k future frames
        elseif (i >= length(T_forw)-k+1)
            l = l + 1;
            % if before last frame
            if ~isequal(k,l)
                T_post(1:k-l) = post_accum(T_forw(i:i+k-1-l));
            end
            T_prev = prev_accum(T_rev(i-k:i-1));
           
        % All the frames, where there is k previous and future frames
        else
            % Accumulate transformations from frame to frame -k,...,curr,...,k
            T_prev = prev_accum(T_rev(i-k:i-1));
            T_post = post_accum(T_forw(i:i+k-1));
        end 

        T{i} = matsushita(k,T_prev,T_post);
    end
end



