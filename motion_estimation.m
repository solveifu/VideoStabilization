function [T] = motion_estimation(vid,type,full_affine)
    num_corners = 500;
    dist_corners = 30;
    qual_corners = 0.01;
    
    if strcmp(type,'affine')
        T = affine_estim(vid,full_affine);
        
    elseif strcmp(type,'feature')
        [corn,flow] = feature_estim(vid,num_corners,qual_corners,dist_corners);
        T = rigid_affine(corn,flow,full_affine);
    end
end

