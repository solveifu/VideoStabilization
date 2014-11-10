function [X_est] = kf(X_n,X_0,m)
    % Pre allocate some variables
    X_est = cell(1,length(X_n));
    X = X_0;

    % Kalman filtering
    for i=1:length(X_n)
        % Prediction of next state and covariance
        X_est{i} = m.A*X + m.B*m.u;
        m.P = m.A*m.P*m.A'+m.Q;

        % Calculate Kalman gain
        K = m.P*m.C'*inv(m.C*m.P*m.C'+m.R);

        % Update state and covariance
        X_est{i} = X_est{i}+K*(X_n(i,:)'-m.C*X_est{i});
        m.P = m.P-K*m.C*m.P;
        
        X = X_est{i};
    end 
end
