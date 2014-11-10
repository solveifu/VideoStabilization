function [T_smud,T] = nghia_method_direct(vid,full_affine,smooth_len)
    % Get transformation matrices
    T = affine_estim(vid,full_affine);
    
    % Convert the affine transform matrix into displacement in x,y and angle
    T_xya = affine2xya(T);

    % Accumulate to a trajectory and smooth
    traj_xya = accum_traj_xya(T_xya);
    traj_xya_smud = smooth_traj_xya(traj_xya,smooth_len);

    % Find the stabilized transformations
    T_smud = nghia(T_xya,traj_xya,traj_xya_smud);
end

