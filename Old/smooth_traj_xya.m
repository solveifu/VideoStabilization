function [traj_new] = smooth_traj_xya(traj,smooth_len)
    traject = cell2mat(traj);    
    
    x = smooth(traject(:,1),smooth_len);
    y = smooth(traject(:,2),smooth_len);
    a = smooth(traject(:,3),smooth_len);
    
    traj_new = cell(length(traject),1);
    for i=1:length(traject)
        traj_new{i} = [x(i) y(i) a(i)];
    end
end

