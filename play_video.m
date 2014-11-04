function [] = play_video(vid_org,vid_trans,play_num,compare)
    %PLAY_VIDEO Function to play the videos. Use 'compare' for playback of both
    % original and transformed video as subplots, 'single' for only vid_trans in the
    % proper Matlab video player.
    if strcmp(compare,'compare')
        for j=1:play_num
            for i=1:length(vid_trans)
                subplot(1,2,1)
                subimage(vid_org(i).cdata)
                subplot(1,2,2)
                subimage(vid_trans(i).cdata)
                drawnow
            end
        end
    elseif strcmp(compare,'single')
        fig = figure
        movie(fig,vid_trans,1,25,[100 100 0 0]);
    end
end

