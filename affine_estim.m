function [T] = affine_estim(vid,full_affine)
    T = cell(length(vid)-1,1); 
    
    if (full_affine)
        for i=1:length(T)
            T{i} = cv.estimateRigidTransform(vid{i},vid{i+1},'FullAffine',1);
            T{i} = [T{i}; 0 0 1];
        end
    else
        for i=1:length(T)
            T{i} = cv.estimateRigidTransform(vid{i},vid{i+1});
            T{i} = [T{i}; 0 0 1];
        end
    end
end

