function [T_smud] = nghia_method(vid,num_corners,qual_corners,dist_corners,full_affine,smooth_len)
    % Find points to track and the optical flow
    [corn,flow] = feature_estim(vid,num_corners,qual_corners,dist_corners);
    
    % Get transformation matrices
    T = rigid_affine(corn,flow,full_affine);
    
    % Convert the affine transform matrix into displacement in x,y and angle
    T_xya = affine2xya(T);

    % Accumulate to a trajectory and smooth
    traj_xya = accum_traj_xya(T_xya);
    traj_xya_smud = smooth_traj_xya(traj_xya,smooth_len);

    % Find the stabilized transformations
    T_smud = nghia(T_xya,traj_xya,traj_xya_smud);
end

