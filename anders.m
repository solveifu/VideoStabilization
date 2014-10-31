clear all; close all;

% Video settings
vid_path_stasj = 'E:\Dokumenter\Dropbox\Testvideoer\';
vid_path_laptop = 'C:\Users\Anders\Dropbox\Testvideoer\';
current_vid = 'colon1.avi';
start_pos = 0; % where to start in seconds
num_frames = 400;

% Stabilization settings
num_corners = 500;
dist_corners = 30;
qual_corners = 0.01;
full_affine = 0;
smooth_len = 30;

% Load the video
%[vid_org,vid] = load_mmreader(strcat(vid_path_stasj,current_vid),start_pos,num_frames);
[vid_org,vid] = load_videoreader(strcat(vid_path_laptop,current_vid),start_pos,num_frames);

% Estimate transformations for stabilization
T_smud = nghia_method(vid,num_corners,qual_corners,dist_corners,full_affine,smooth_len);

% Warp frames
vid_trans = warp(vid_org,T_smud);

% Play video 5 times
play_video(vid_org,vid_trans,5);



