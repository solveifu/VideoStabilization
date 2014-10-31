function [T] = rigid_affine(src,dst,full_affine)
    T = cell(length(src)-1,1);
    
    if (full_affine)
        for i=1:length(T)
            T{i} = cv.estimateRigidTransform(src{i},dst{i},'FullAffine',1);
        end
    else
        for i=1:length(T)
            T{i} = cv.estimateRigidTransform(src{i},dst{i});
        end
    end

end

