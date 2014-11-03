function [T,T_forw] = matsushita_method(k,vid,num_corners,qual_corners,dist_corners,full_affine)
    % Find points to track and the optical flow
    [corn,flow] = feature_estim(vid,num_corners,qual_corners,dist_corners);
    
    % Get transformation matrices
    T_forw = rigid_affine(corn,flow,full_affine);
    inv(T_forw{1})
    
    T_rev = cellfun(@inv,T_forw,'un',0);
    T_prev = cell(k,1);
    T_post = cell(k,1);
    T = cell(length(T_forw),1);
    for i=1:380
        % The first frames, where there is less than k previous frames
        if (i <= k)
            % If later than first frame
            if ~isequal(i,1)
                %for j=1:i-1
                    T_prev(k-i+2:k,1) = prev_accum(T_rev(1:i-1));
                    
                %end
            end
            T_post = post_accum(T_forw(i:i+k-1));
                 
        % The last frames, where there is less than k future frames
        elseif (i >= length(vid)-k)
            
            
        % All the frames, where there is k previous and future frames
        else
            % Accumulate transformations from frame to frame -k,...,curr,...,k
            %for j=1:k-1
            %    idx = i-k+j;
                T_prev = prev_accum(T_rev(i-k:i-1));
            %end
            %T_prev{k} = T_forw{i};
            %T_post{1} = T_rew{i};
            %for j=1:k
                T_post = post_accum(T_forw(i:i+k-1));
            %end
        end 
        % Remove empty cells
        %T_prev(~cellfun('isempty',T_prev));     
        %T_post(~cellfun('isempty',T_post)); 
        T{i} = matsushita(k,T_prev,T_post);
    end
end
        
%       T = cell(2*k+1,1);
%       T(1:k,1) = T_prev(1:k,1);
%       T{k+1,1} = [1 0 0;0 1 0;0 0 1];
%       T(k+2:end,1) = T_post(1:k,1);
%       for m=1:length(T);
%           if(isempty(T{m}))
%               T{m} = [1 0 0;0 1 0;0 0 1];
%           end
%       end
%      
%      
%       n=1:4*k+1;
%       dev=10*sqrt(k);
%       G_k = 1/(sqrt(2*pi)*dev)*exp(-(n-(2*k+1)).^2/(2*dev^2));
%      
%       Si = zeros(3,3);
%       for m=1:3
%           for n=1:3
%               param = get_vector(T,m,n)';
%               Si(m,n) = sum(param);
%           end
%       end
%       %Si = Si./Si(3,3);
%       S{i} = Si; 
%         
%     end
%     n=1:4*k+1;
%     dev=10*sqrt(k);
%     G_k = 1/(sqrt(2*pi)*dev)*exp(-(n-(2*k+1)).^2/(2*dev^2));
%     
%      for i=1:3
%          for j=1:3
%              param = get_vector(S,i,j)';
%              out = conv(param,G_k,'same');
%              for l=1:length(S)
%                  S{l}(i,j) = out(l);
%              end
%          end
%      end
%      %S = S./S(3,3);
%      for l=1:length(S)
%          S{l} = S{l}./S{l}(3,3);
%      end


