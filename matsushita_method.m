function [T] = matsushita_method(k,vid,num_corners,qual_corners,dist_corners,full_affine)
    corn = find_corners(vid,num_corners,qual_corners,dist_corners);
    flow_up = cell(length(k),1);
    flow_down = cell(length(k),1);
    T = cell(length(vid)-1,1);
    
    for i=1:length(vid)-k-1  
        if (i <= k)
            for j=1:k
                flow_up{j} = cv.calcOpticalFlowPyrLK(vid{i},vid{i+j},corn{i});
            end
            for j=1:i-1
                flow_down{j} = cv.calcOpticalFlowPyrLK(vid{i},vid{i-j},corn{i});
            end
        elseif (i >= length(vid)-k)
            for j=1:k
                flow_down{j} = cv.calcOpticalFlowPyrLK(vid{i},vid{i-j},corn{i});
            end
            for j=1:i-1
                flow_up{j} = cv.calcOpticalFlowPyrLK(vid{i},vid{i+j},corn{i});
            end
        else
            for j=1:k
                flow_up{j} = cv.calcOpticalFlowPyrLK(vid{i},vid{i+j},corn{i});
                flow_down{j} = cv.calcOpticalFlowPyrLK(vid{i},vid{i-j},corn{i});
            end
        end 
        % Remove empty cells
        flow_up(~cellfun('isempty',flow_up));     
        flow_down(~cellfun('isempty',flow_down)); 
        
        T{i} = matsushita(k,corn{i},flow_down,flow_up,full_affine);
    end
end

