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

% Load the video
%[vid_org,vid] = load_mmreader(strcat(vid_path_stasj,current_vid),start_pos,num_frames);
%[vid_org,vid] = load_videoreader(strcat(vid_path_laptop,current_vid),start_pos,num_frames);
[vid_org,vid] = load_videoreader(current_vid,start_pos,num_frames);

% Estimate transformations for stabilization
[T_smud_nghia,T] = nghia_method(vid,num_corners,qual_corners,dist_corners,full_affine,smooth_len);
T_smud_mat = matsushita_method(50,vid,num_corners,qual_corners,dist_corners,1);

% Warp frames
crop_border = 60;
vid_trans = warp(vid_org,T_smud_nghia(1:num_frames-20),crop_border);

% Play both videos 5 times
play_video(vid_org,vid_trans,5,'compare');

% Play stabilized video 2 times
play_video(vid_org,vid_trans,1,'single');

% Plot trajectory for both Nghia and Matsushita
figure
trajectory_plotter(T(1:num_frames-20),T_smud_nghia(1:num_frames-20))
figure
trajectory_plotter(T(1:num_frames-20),T_smud_mat(1:num_frames-20))

