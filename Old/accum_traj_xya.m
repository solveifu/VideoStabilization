function [traj] = accum_traj_xya(T)
    x = 0; y = 0; a = 0;
    traj = cell(length(T),1);
    for i=1:length(T)
        x = x + T{i}(1);
        y = y + T{i}(2);
        a = a + T{i}(3);
        
        traj{i} = [x y a];
    end
end

