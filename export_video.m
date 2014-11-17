function export_video(vid,filename)
%EXPORT_VIDEO Summary of this function goes here
%   Detailed explanation goes here
writerObj = VideoWriter(filename);
writerObj.open;
writerObj.writeVideo(vid);
writerObj.close;

end

