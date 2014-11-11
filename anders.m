clear all; close all;

% Video settings
vid_path_stasj = 'E:\Dokumenter\Dropbox\Testvideoer\';
vid_path_laptop = 'C:\Users\Anders\Dropbox\Testvideoer\';
current_vid = 'hippo.mp4';
start_pos = 0; % where to start in seconds
num_frames = 400;

% Stabilization settings
num_corners = 500;
dist_corners = 30;
qual_corners = 0.01;
full_affine = 0;
smooth_len = 100;

% Dynamic model
% System noise, smaller value give more smoothing
sigma_z = 0.001;        % zoom, a2/a3
sigma_r = 0.04;         % rotation, a1/a4
sigma_b = 0.0001;   % translation, b1/b2

% Observation noise, larger value gives more smoothing
sigma_obs_z = 1;        % zoom, a2/a3
sigma_obs_r = 1;        % rotation, a1/a4
sigma_obs_b = 1;        % translation, b1/b2

% Load the video
%[vid_org,vid] = load_mmreader(strcat(vid_path_stasj,current_vid),start_pos,num_frames);
%[vid_org,vid] = load_videoreader(strcat(vid_path_laptop,current_vid),start_pos,num_frames);
[vid_org,vid] = load_videoreader(current_vid,start_pos,num_frames);

% Estimate transformations for stabilization
%[T_smud_nghia_feature,T_feature] = nghia_method(vid,num_corners,qual_corners,dist_corners,full_affine,smooth_len);
[T_smud_nghia_direct,T_direct] = nghia_method_direct(vid,1,smooth_len);
[T_smud,T] = matsushita_method(30,vid,num_corners,qual_corners,dist_corners,1);
[T_smud_litvin,T] = litvin_method(vid,1,sigma_z,sigma_r,sigma_b,sigma_obs_z,sigma_obs_r,sigma_obs_b);

% Warp frames
crop_border = 60;
%vid_trans_feature = warp(vid_org,T_smud_nghia_feature,crop_border);
%vid_trans_direct = warp(vid_org,T_smud_nghia_direct,crop_border);
vid_trans_lit = warp(vid_org,T_smud_litvin,crop_border);
vid_trans_mat = warp(vid_org(1:num_frames-20),T_smud_litvin(1:num_frames-20),crop_border);

% Play both videos 5 times
play_video(vid_org,vid_trans_lit,5,'compare');

% COmpare two transformed videos
play_video(vid_trans_lit,vid_trans_mat,5,'compare');

% Play stabilized video 2 times
play_video(vid_org,vid_trans_lit,1,'single');

% Plot trajectory for both Nghia and Matsushita
figure
trajectory_plotter(T_feature,T_smud_nghia_feature,'Nghia feature estimation')
figure
trajectory_plotter(T_direct,T_smud_nghia_direct,'Nghia direct estimation')

% Matsukisatas 
figure
trajectory_plotter(T(1:num_frames-20),T_smud(1:num_frames-20),'Matsushita')

% Litvins
figure
trajectory_plotter(T,T_smud_litvin,'Litvin');


