function [T] = rigid_affine(src,dst,full_affine)
    if isequal(length(src(:,1)),1)
        % single frame transformation
        T = cell(1,1); 
    else
        % Frame to frame transformation for whole video
        T = cell(length(src)-1,1); 
    end
    
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

