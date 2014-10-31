function [a] = play_video(vid1,vid2,play_num)
    for j=1:play_num
        for i=1:length(vid1)
            subplot(1,2,1)
            subimage(vid1(i).cdata)
            subplot(1,2,2)
            subimage(vid2(i).cdata)
            drawnow
        end
    end
end

