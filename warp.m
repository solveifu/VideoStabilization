function [vid_trans] = warp(vid,T)
    width = length(vid(1).cdata(1,:,1));
    height = length(vid(1).cdata(:,1,1));
    
    vid_trans(1:length(vid)) = struct('cdata',uint8(zeros(height,width,3)),'colormap',[]); 
    for i=1:length(T)
        % Transform for each color band
        for j=1:3
            vid_trans(i).cdata(:,:,j) = uint8(cv.warpAffine(vid(i).cdata(:,:,j),T{i}(1:2,1:3)));
        end
    end
end