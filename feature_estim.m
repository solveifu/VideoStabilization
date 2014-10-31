function [T] = feature_estim(vid,num_corners,qual_corners,dist_corners,full_affine)
    % Find corners
    corn = find_corners(vid,num_corners,qual_corners,dist_corners);

    % Calculate optical flow
    flow = calc_opt_flow(vid,corn);

    % Get transformation
    T = rigid_affine(corn,flow,full_affine);
end

