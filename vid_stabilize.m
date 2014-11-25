clear all; close all;

% Video settings
vid_path = 'D:\Testvideoer\';   % video path
current_vid = 'hippo.mp4';      % video name
start_pos = 0;                  % where to start in seconds
num_frames = 200;               % number of frames
num_play = 1;                   % times to play videos

% Stabilization settings
full_affine = 1;            % use full affine transformation
k = 50;                     % number of frames to smooth in Matsushita
crop_border = 40;           % how many pixels to crop from videos

% Litvin settings           System noise, smaller value give more smoothing
sigma_z = 0.0001;           % - rotation, a2/a3
sigma_r = 0.009;            % - zoom, a1/a4
sigma_b = 0.0002;           % - translation, b1/b2
                            % Observation noise, larger value gives more smoothing
sigma_obs_z = 1;            % - rotation, a2/a3
sigma_obs_r = 1;            % - zoom, a1/a4
sigma_obs_b = 1;            % - translation, b1/b2
tic
% Load the video
[vid_org,vid] = load_videoreader(current_vid,start_pos,num_frames);

% Estimate motion
T = motion_estimation(vid,'affine',full_affine);

% Estimate warp transformations for stabilization
S_mat = matsushita_method(T,k);
S_lit = litvin_method(T,sigma_z,sigma_r,sigma_b,sigma_obs_z,sigma_obs_r,sigma_obs_b);

% Warp frames, cropping if crop_border > 0
vid_lit = warp(vid_org,S_lit,crop_border);
vid_mat = warp(vid_org,S_mat,crop_border);
vid_crop = crop(vid_org,crop_border);
toc
% Compare both videos to the original
play_video(vid_crop,vid_lit,num_play,'compare');
play_video(vid_crop,vid_mat,num_play,'compare');

% Compare the two transformed videos
play_video(vid_mat,vid_lit,num_play,'compare');

% Plot trajectories
figure
trajectory_plotter_comp(T,S_lit,S_mat,1,'NorthEast');

% Export videos
export_video(vid_mat,strcat(current_vid,'_matsushita'));
export_video(vid_lit,strcat(current_vid,'_litvin'));

