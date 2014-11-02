function [T,T_forw] = matsushita_method(k,vid,num_corners,qual_corners,dist_corners,full_affine)
    % Find points to track and the optical flow
    [corn,flow] = feature_estim(vid,num_corners,qual_corners,dist_corners);
    
    % Get transformation matrices
    T_forw = rigid_affine(corn,flow,full_affine);
    inv(T_forw{1})
    
    T_rev = cellfun(@inv,T_forw,'un',0);
    T_prev = cell(1,k);
    T_post = cell(1,k);
    T = cell(length(T_forw),1);
    for i=1:380
        
        % The first frames, where there is less than k previous frames
        if (i <= k)
            % If later than first frame
            if ~isequal(i,1)
                for j=1:i-1
                    T_prev = prev_accum(T_forw(i-j:i-1));
                end
            end
            T_post = post_accum(T_rev(i:i+k-1));
                 
        % The last frames, where there is less than k future frames
        elseif (i >= length(vid)-k)
            
            
        % All the frames, where there is k previous and future frames
        else
            % Accumulate transformations from frame to frame -k,...,curr,...,k
            %for j=1:k-1
            %    idx = i-k+j;
                T_prev = prev_accum(T_forw(i-k:i-1));
            %end
            %T_prev{k} = T_forw{i};
            %T_post{1} = T_rew{i};
            %for j=1:k
                T_post = post_accum(T_rev(i:i+k-1));
            %end
        end 
        % Remove empty cells
        %T_prev(~cellfun('isempty',T_prev));     
        %T_post(~cellfun('isempty',T_post)); 
        
        T{i} = matsushita(k,T_prev,T_post);
    end
end

