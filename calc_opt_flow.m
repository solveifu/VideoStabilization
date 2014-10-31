function [flow] = calc_opt_flow(vid,corners)
    flow = cell(length(vid)-1,1);
    for i=1:length(flow)
       [flow{i}, status] = cv.calcOpticalFlowPyrLK(vid{i},vid{i+1},corners{i});
       if ~(min(status))
           disp('Optical flow not found for one frame.');
       end
    end
end

