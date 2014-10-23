clear all; close all;

% Path to videos and settings
vid_path = 'C:\Users\Anders\Dropbox\Testvideoer\';
current_vid = 'hippo.mp4';
start_pos = 0; % where to start in seconds
num_frames = 100;
vid_bands = 3;
num_corners = 500;
smooth_len = 30;

% Read the video
vid_obj = VideoReader(strcat(current_vid));
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
T(1:num_frames-1) = struct('affine',zeros(2,3),'dx',[],'dy',[],'da',[],'dx_',[],'dy_',[],'da_',[],'x',[],'y',[],'a',[],'x_',[],'y_',[],'a_',[]);
x = 0; y = 0; a = 0;
for i=1:num_frames-1
    T(i).affine = cv.estimateRigidTransform(corners(i).frames,flow(i).next_pts);
    if isempty(T(i).affine)
        T(i).affine = T(i-1).affine;
    end
    
    % Decompose the affine transform in x,y,phi
    T(i).dx = T(i).affine(1,3);
    T(i).dy = T(i).affine(2,3);
    T(i).da = atan(T(i).affine(2,1)/T(i).affine(2,2));
    
    % Accumulate trajectories
    x = x + T(i).dx;
    y = y + T(i).dy;
    a = a + T(i).da;
    
    T(i).x = x;
    T(i).y = y;
    T(i).a = a;
end

% Smooth trajectory. This could be done more elegant without the loop
x_ = smooth([T(:).x],smooth_len);
y_ = smooth([T(:).y],smooth_len);
a_ = smooth([T(:).a],smooth_len);
for i=1:num_frames-1
    T(i).x_ = x_(i);
    T(i).y_ = y_(i);
    T(i).a_ = a_(i);
end

% Plot the differences between consecutive frames
clf
hold on
plot([T(:).dx]);
plot([T(:).dy],'r');
hold off

% Plot trajectories
clf
hold on
plot([T(:).x]);
plot([T(:).y],'r');
plot([T(:).x_],':');
plot([T(:).y_],':r');
hold off

% Find the new transforms
T_ = cell(1,length(T));
for i=1:num_frames-1
    % method of Nghia Ho (blog)
    dx = T(i).dx + T(i).x_ - T(i).x;
    dy = T(i).dy + T(i).y_ - T(i).y;
    da = T(i).da + T(i).a_ - T(i).a;

    % Get the new transform matrices
    T_{i} = [cos(da) -sin(da) dx; sin(da) cos(da) dy];
end

% Computing the T transformation chain to separate S matrices for each
% frame. Method from Matsushita. NB! Uses S as transform, needs to be
% changed in warping. But it does not work yet...
%{
k = 6;
sigma = sqrt(k);
S = cell(1,length(T));
T_ = cell(1,length(T)+2*k);
T_(1:k) = {zeros(2,3)};
for i=1:length(T)
    T_{i+k} = T(i).affine;
end
T_(end-k:end) = {zeros(2,3)};
S(:) = {zeros(2,3)};
for i=1:length(S)
    for j=1:2*k
        % Formula (1): S_t = sum_i=N_t{T_t^i*G(k)} G(k) gaussian kernel
        S{i} = S{i} + conv2(T_{i+j-1},1/(sqrt(2*pi)*sigma)*exp(-k^2/(2*sigma^2)));
    end
end
%}

% Warp each frame by the calculated affine tranformation matrix
% Structure chosen like this to be playable in figure
vid_trans(1:num_frames) = struct('cdata',uint8(zeros(vid_obj.Height,vid_obj.Width,vid_bands)),'colormap',[]); 
for i=1:num_frames-1
    for j=1:vid_bands
        vid_trans(i).cdata(:,:,j) = uint8(cv.warpAffine(vid_org(i).cdata(:,:,j),T_{i}));
    end
end

w = vid_obj.Width;
h = vid_obj.Height;
b = 20; % border in px

vid_trans_cr(1:num_frames) = struct('cdata',uint8(zeros(h-2*b+1,w-2*b+1,3)),'colormap',[]); 
for i=1:num_frames-1
    vid_trans_cr(i).cdata(:,:,:) = vid_trans(i).cdata(b:h-b,b:w-b,:);
end

% Play stabilized movie 5 times
fig = figure
set(fig, 'position', [150 150 569 377])
movie(fig, vid_trans_cr, 5, vid_obj.FrameRate);

% Play original movie 5 times
fig2 = figure
set(fig2, 'position', [150 150 vid_obj.Width vid_obj.Height])
movie(fig2, vid_trans, 5, vid_obj.FrameRate);

% Hacky way to play both original and transformed video
while (1)
    for i=1:num_frames
        subplot(1,2,1)
        subimage(vid_org(i).cdata)
        subplot(1,2,2)
        subimage(vid_trans_cr(i).cdata)
        drawnow
    end
end
