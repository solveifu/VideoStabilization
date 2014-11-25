clear all; close all;

% Video settings
vid_path_stasj = 'C:\Users\Anders\Dropbox\Biomedical - Project Papers\video_export\';
vid_path_laptop = 'D:\Testvideoer\';
current_vid = 'fish_orig.avi';
start_pos = 0; % where to start in seconds
num_frames = 200;

% Stabilization settings
full_affine = 1;
smooth_len = 100;
k = 50;

% Dynamic model         % System noise, smaller value give more smoothing
sigma_z = 0.0001;        % - rotation, a2/a3
sigma_r = 0.009;         % - zoom, a1/a4
sigma_b = 0.0002;       % - translation, b1/b2
                        % Observation noise, larger value gives more smoothing
sigma_obs_z = 1;        % - rotation, a2/a3
sigma_obs_r = 1;        % - zoom, a1/a4
sigma_obs_b = 1;        % - translation, b1/b2

% Load the video
%[vid_org,vid] = load_videoreader(strcat(vid_path_stasj,current_vid),start_pos,num_frames);
%[vid_org,vid] = load_videoreader(strcat(vid_path_laptop,current_vid),start_pos,num_frames);
[vid_org,vid] = load_videoreader(current_vid,start_pos,num_frames);

% Estimate motion
T = motion_estimation(vid,'affine',full_affine);

% Estimate transformations for stabilization for Nghia, Matsushita, Litvin
%T_nghia = nghia_method(T,smooth_len);
T_mat = matsushita_method(T,k);
tic
T_lit = litvin_method(T,sigma_z,sigma_r,sigma_b,sigma_obs_z,sigma_obs_r,sigma_obs_b);
toc
% Warp frames, cropping if crop_border > 0
crop_border = 40;
vid_lit = warp(vid_org,T_lit,crop_border);
vid_mat = warp(vid_org,T_mat,crop_border);
%vid_nghia = warp(vid_org,T_nghia,crop_border);
vid_crop = crop(vid_org,crop_border);

% The videos to compare
vid_play1 = vid_lit;
vid_play2 = vid_mat;

% Play both videos 5 times
play_video(vid_org,vid_crop,5,'compare');

% Compare two transformed videos
play_video(vid_play1,vid_play2,5,'compare');

% Play stabilized video 2 times
play_video(vid_org,vid_play1,1,'single');

% Plot trajectories
% Nghia 
figure
trajectory_plotter(T,T_nghia,'Nghia')

% Matsukisatas 
figure
trajectory_plotter(T,T_mat,'Matsushita')

% Litvins
figure
trajectory_plotter(T,T_lit,'Litvin');

% Compare trajectories
figure
trajectory_plotter_comp(T,T_lit,T_mat);


% Load the video
%[vid,vid_yt] = load_videoreader('Colonoskopi_28117934987_20130326_2036_youtube.mp4',start_pos,num_frames);
[vid2,vid_yt] = load_videoreader('fish_youtube.mp4',start_pos,num_frames);

% Estimate motion
T_yt = motion_estimation(vid_yt,'affine',full_affine);

% Grundmann
figure
trajectory_compare(T,T_yt,'Grundmann');

%play_video(vid,vid,1,'single');
%export_video(vid_org,'testvideo_org');

