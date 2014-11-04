function [vid_trans] = warp(vid,T,border)
    width = length(vid(1).cdata(1,:,1));
    height = length(vid(1).cdata(:,1,1));
    
    vid_trans_full(1:length(vid)) = struct('cdata',uint8(zeros(height,width,3)),'colormap',[]); 
    for i=1:length(T)
        % Transform for each color band
        for j=1:3
            vid_trans_full(i).cdata(:,:,j) = uint8(cv.warpAffine(vid(i).cdata(:,:,j),T{i}(1:2,1:3)));
        end
    end
    if ~isequal(border,0)
        w = width - border;
        h = height - border;
        b = border;
        vid_trans(1:length(vid)) = struct('cdata',uint8(zeros(h-b+1,w-b+1,3)),'colormap',[]); 
        for i=1:length(T)
            % Transform for each color band
            for j=1:3
                vid_trans(i).cdata(:,:,j) = vid_trans_full(i).cdata(b:h,b:w,j);
            end
        end
    else
        vid_trans = vid_trans_full;
    end
end