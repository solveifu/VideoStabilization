function [corners] = find_corners(vid,num,qual,dist)
    corners = cell(length(vid),1);
    for i=1:length(corners)
        corners{i} = cv.goodFeaturesToTrack(vid{i},'MaxCorners',num,'QualityLevel',qual,'MinDistance',dist);
    end
end

