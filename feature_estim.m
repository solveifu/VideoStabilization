function [corn,flow] = feature_estim(vid,num_corners,qual_corners,dist_corners)
    % Find corners
    corn = find_corners(vid,num_corners,qual_corners,dist_corners);

    % Calculate optical flow
    flow = calc_opt_flow(vid,corn,1);
end

