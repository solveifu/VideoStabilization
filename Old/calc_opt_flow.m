function [flow] = calc_opt_flow(vid,corners,dir_up)
    flow = cell(length(corners)-1,1);
    
    if (dir_up)
        dir = 1;
    else
        dir = -1;
    end
        
    for i=1:length(flow)
       [flow{i}, status] = cv.calcOpticalFlowPyrLK(vid{i},vid{i+dir},corners{i});
       if ~(min(status))
           disp('Optical flow not found for one frame.');
       end
    end
end

