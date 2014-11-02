function [T] = matsushita_method(k,vid,num_corners,qual_corners,dist_corners,full_affine)
    % Find points to track and the optical flow
    [corn,flow] = feature_estim(vid,num_corners,qual_corners,dist_corners);
    
    % Get transformation matrices
    T_forw = rigid_affine(corn,flow,full_affine);
    inv(T_forw{1})
    
    T_rew = cellfun(@inv,T_forw,'un',0);

    for i=1:length(vid)-k-1  
        % The first frames, where there is less than k previous frames
        if (i <= k)
            for j=1:k
                flow_up{j} = cv.calcOpticalFlowPyrLK(vid{i},vid{i+j},corn{i});
            end
            for j=1:i-1
                flow_down{j} = cv.calcOpticalFlowPyrLK(vid{i},vid{i-j},corn{i});
            end
        % The last frames, where there is less than k future frames
        elseif (i >= length(vid)-k)
            for j=1:k
                flow_down{j} = cv.calcOpticalFlowPyrLK(vid{i},vid{i-j},corn{i});
            end
            for j=1:i-1
                flow_up{j} = cv.calcOpticalFlowPyrLK(vid{i},vid{i+j},corn{i});
            end
        % All the frames, where there is k previous and future frames
        else
            for j=1:k
                flow_up{j} = cv.calcOpticalFlowPyrLK(vid{i},vid{i+j},corn{i});
                flow_down{j} = cv.calcOpticalFlowPyrLK(vid{i},vid{i-j},corn{i});
            end
        end 
        % Remove empty cells
        flow_up(~cellfun('isempty',flow_up));     
        flow_down(~cellfun('isempty',flow_down)); 
        
        T{i} = matsushita(k,T_prev,T_post,full_affine);
    end
end

