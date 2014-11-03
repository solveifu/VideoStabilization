function [T] = nghia(T_xya,traj_xya,traj_xya_smooth)
    T_xya_new = cell(length(T_xya),1);
    
    for i=1:length(T_xya)
        % method of Nghia Ho (blog)
        T_xya_new{i}(1) = T_xya{i}(1) + traj_xya_smooth{i}(1) - traj_xya{i}(1);
        T_xya_new{i}(2) = T_xya{i}(2) + traj_xya_smooth{i}(2) - traj_xya{i}(2);
        T_xya_new{i}(3) = T_xya{i}(3) + traj_xya_smooth{i}(3) - traj_xya{i}(3);
        %T_xya_new{i}(1) = traj_xya_smooth{i}(1) - traj_xya{i}(1);
        %T_xya_new{i}(2) = traj_xya_smooth{i}(2) - traj_xya{i}(2);
        %T_xya_new{i}(3) = traj_xya_smooth{i}(3) - traj_xya{i}(3);
    end
    
    T = xya2affine(T_xya_new);
end

