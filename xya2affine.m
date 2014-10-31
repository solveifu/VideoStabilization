function [T] = xya2affine(xya)
    T = cell(length(xya),1);
    
    for i=1:length(T)
        dx = xya{i}(1);
        dy = xya{i}(2);
        da = xya{i}(3);
        
        T{i} = [cos(da) -sin(da) dx; sin(da) cos(da) dy];
    end
end

