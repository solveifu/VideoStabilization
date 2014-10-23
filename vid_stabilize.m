clear all; close all;

% Path to videos and settings
vid_path = 'C:\Users\Anders\Dropbox\Testvideoer\';
current_vid = 'colon1.avi';
num_frames = 200;
start_pos = 0; % where to start in seconds
vid_bands = 3;
num_corners = 500;
smooth_len = 20;

% Read the video
vid_obj = VideoReader(strcat(vid_path,current_vid));
vid_raw = read(vid_obj,[start_pos*vid_obj.FrameRate+1 start_pos*vid_obj.FrameRate+num_frames]); %outputs matrix HxWxBxF

% Video frames with RGB and Y components in one structure
vid_org(1:num_frames) = struct('cdata',zeros(vid_obj.Width,vid_obj.Height,vid_bands),'colormap',[]);
vid(1:num_frames) = struct('y',zeros(vid_obj.Width,vid_obj.Height));
for i=1:num_frames
    vid_org(i).cdata = vid_raw(:,:,:,i);
    vid(i).y = cv.cvtColor(vid_raw(:,:,:,i),'RGB2GRAY'); %RBG to YUV transform. Keeps only the luminance
end
clear vid_raw; % clear to save some memory, only vid will be used

% Find corners in the video frames
corners = struct('frames',cell(1,num_frames));
for i=1:num_frames
    corners(i).frames = cv.goodFeaturesToTrack(vid(i).y,'MaxCorners',num_corners,'QualityLevel',0.01,'MinDistance',30);
end

% Calculate optical flow by use of the corners 
flow = struct('next_pts',cell(1,num_frames),'status',zeros(num_frames,1),'error',zeros(num_frames,1));
for i=1:num_frames-1
   [flow(i).next_pts, flow(i).status, flow(i).error] = cv.calcOpticalFlowPyrLK(vid(i).y,vid(i+1).y,corners(i).frames);
end

% Find transform from each frame to the next
T(1:num_frames-1) = struct('affine',zeros(2,3),'dx',[],'dy',[],'da',[],'dx_',[],'dy_',[],'da_',[]);
for i=1:num_frames-1
    T(i).affine = cv.estimateRigidTransform(corners(i).frames,flow(i).next_pts);
    if isempty(T(i).affine)
        T(i).affine = T(i-1).affine;
    end
    
    % Decompose the affine transform in x,y,phi
    T(i).dx = T(i).affine(1,3);
    T(i).dy = T(i).affine(2,3);
    T(i).da = atan(T(i).affine(2,1)/T(i).affine(2,2));
end

% Smooth the differences. This could be done more elegant without the loop
dx_ = smooth([T(:).dx],smooth_len);
dy_ = smooth([T(:).dy],smooth_len);
da_ = smooth([T(:).da],smooth_len);
for i=1:num_frames-1
    T(i).dx_ = dx_(i);
    T(i).dy_ = dy_(i);
    T(i).da_ = da_(i);
end

% Plot the differences between consecutive frames
clf
hold on
plot([T(:).dx]);
plot([T(:).dy],'r');
plot(dx_,'g');
plot(dy_,'k');
hold off

% Computing the T transformation chain to separate S matrices for each
% frame. Method from Matsushita
% TODO, what the fuck is meant by the indices of the neighboring
% frames used in the summing? The set of values N
%S(1:num_frames) = struct('trans',zeros(2,3));
%k = 6;
%for i=1:num_frames
%    for j=1:k
%    S(i).trans = conv2(T(i).affine,fspecial('gaussian',[2 3],sqrt(k)));
%    end
%end

% Find the new transforms by method of Nghia Ho (blog)
T_ = cell(1,length(T));
x = 0; y = 0; a = 0;
for i=1:num_frames-1
    % Accumulate the trajectories
    x = x + T(i).dx;
    y = y + T(i).dy;
    a = a + T(i).da;
    
    
    dx = T(i).dx + T(i).dx_ - x;
    dy = T(i).dy + T(i).dy_ - y;
    da = T(i).da + T(i).da_ - a;
    
    % Get the new transform matrices
    T_{i} = [cos(da) -sin(da) dx; sin(da) cos(da) dy];
end
    
% Warp each frame by the calculated affine tranformation matrix
% Structure chosen like this to be playable in figure
vid_trans(1:num_frames) = struct('cdata',uint8(zeros(vid_obj.Height,vid_obj.Width,vid_bands)),'colormap',[]); 
for i=1:num_frames-1
    for j=1:vid_bands
        vid_trans(i).cdata(:,:,j) = uint8(cv.warpAffine(vid_org(i).cdata(:,:,j),T_{i}));
    end
end

% Play stabilized movie 5 times
fig = figure
set(fig, 'position', [150 150 vid_obj.Width vid_obj.Height])
movie(fig, vid_trans, 5, vid_obj.FrameRate);

% Play original movie 5 times
fig2 = figure
set(fig2, 'position', [150 150 vid_obj.Width vid_obj.Height])
movie(fig2, vid_org, 5, vid_obj.FrameRate);

% Hacky way to play both original and transformed video
for i=1:num_frames
    subplot(1,2,1)
    subimage(vid_org(i).cdata)
    subplot(1,2,2)
    subimage(vid_trans(i).cdata)
    drawnow
end
