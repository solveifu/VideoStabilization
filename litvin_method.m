function [T_smud,T] = litvin_method(vid,full_affine,sigma_z,sigma_r,sigma_b,sigma_obs_z,sigma_obs_r,sigma_obs_b)

    % Get transformation matrices
    T = affine_estim(vid,full_affine);
    
    % Accumulate the transformations
    T_acc = matrix_accum(T);
    
    % Create the dynamic model
    m.A = diag(ones(1,10))+[zeros(9,1) diag([1 0 1 0 0 0 1 0 1]); zeros(1,10)];
    m.B = zeros(10,1);
    m.C = [1 0 0 0 0 0 0 0 0 0;
           0 0 0 0 1 0 0 0 0 0;
           0 0 0 0 0 1 0 0 0 0;
           0 0 1 0 0 0 0 0 0 0;
           0 0 0 0 0 0 1 0 0 0;
           0 0 0 0 0 0 0 0 1 0];
    m.u = 0;
    m.P = eye(10)*0.5;
    m.Q = diag([0 sigma_z^2 0 sigma_z^2 sigma_r^2 sigma_r^2 0 sigma_b^2 0 sigma_b^2]);
    m.R = diag([sigma_obs_z^2 sigma_obs_r^2 sigma_obs_r^2 sigma_obs_z^2 sigma_obs_b^2 sigma_obs_b^2]);
    
    % Change the transformations matrices to observation matrix form
    X_n = zeros(length(T_acc),6);
    for i=1:length(T_acc)
        X_n(i,:) = [T_acc{i}(1,1:2) T_acc{i}(2,1:2) T_acc{i}(1:2,3)'];
    end
    
    % The initial estimate is just the first transform with no movement
    X_0 = [X_n(1,1) 0 X_n(1,4) 0 X_n(1,2) X_n(1,3) X_n(1,5) 0 X_n(1,6) 0]';
    
    % Estimate the intended movement by Kalman filter
    T_est = kf(X_n,X_0,m);
    
    % Change form of the estimated movement to 3x3 matrices
    T_hat = cell(1,length(T_est));
    for i=1:length(T_acc)
        T_hat{i} = [T_est{i}(1) T_est{i}(5) T_est{i}(7); T_est{i}(6) T_est{i}(3) T_est{i}(9); 0 0 1];
    end
    
    % Get the stabilized transforms by inverting the accumuated and
    % applying estimate
    T_smud = cell(length(T_est),1);
    for i=1:length(T_smud)
        T_smud{i} = T{i}*T_hat{i}*inv(T_acc{i});
    end
end

