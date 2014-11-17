function [vid_crop] = crop(vid,border)
    width = length(vid(1).cdata(1,:,1));
    height = length(vid(1).cdata(:,1,1));
    
    w = width - border;
    h = height - border;
    b = border;
    vid_crop(1:length(vid)) = struct('cdata',uint8(zeros(h-b+1,w-b+1,3)),'colormap',[]); 
    for i=1:length(vid)
        % Transform for each color band
        for j=1:3
            vid_crop(i).cdata(:,:,j) = vid(i).cdata(b:h,b:w,j);
        end
    end
end

