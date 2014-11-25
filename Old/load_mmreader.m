% Function used to load the video, for use with old Matlab versions.
function [vid_org,vid] = load_mmreader(path,start_pos,num_frames)
    % Create the video object
    vid_obj = mmreader(path);
    vid_raw = read(vid_obj,[start_pos*vid_obj.FrameRate+1 start_pos*vid_obj.FrameRate+num_frames]); %outputs matrix HxWxBxF

    % Video frames with RGB and Y components in one structure
    vid_org(1:num_frames) = struct('cdata',zeros(vid_obj.Width,vid_obj.Height,3),'colormap',[]);
    vid = cell(num_frames,1);
    
    % Read out all frames to the struct format used for playback in Matlab
    for i=1:num_frames
        vid_org(i).cdata = vid_raw(:,:,:,i);
        vid{i} = cv.cvtColor(vid_raw(:,:,:,i),'RGB2GRAY'); %RBG to YUV transform. Keeps only the luminance
    end
end
