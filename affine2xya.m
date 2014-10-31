function [T_new] = affine2xya(T)
    T_new = cell(length(T),1);
    for i=1:length(T)
        dx = T{i}(1,3);
        dy = T{i}(2,3);
        da = atan(T{i}(2,1)/T{i}(2,2));
        
        T_new{i} = [dx dy da];
    end
end

