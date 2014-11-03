clear all; close all;

% Video settings
vid_path = 'C:\Users\Harald\Documents\Dropbox\Studier\Semester 09\Biomedisinsk signalbehandling\matlab_work\Testvideoer\';
current_vid = 'colon1.avi';
start_pos = 0; % where to start in seconds
num_frames = 400;

% Stabilization settings
num_corners = 500;
dist_corners = 30;
qual_corners = 0.01;
full_affine = 0;
smooth_len = 50;

% Load the video
[vid_org,vid] = load_videoreader(strcat(vid_path,current_vid),start_pos,num_frames);

% Estimate transformations for stabilization
%[T_smud,T] = nghia_method(vid,num_corners,qual_corners,dist_corners,full_affine,smooth_len);
[T_smud,T] = matsushita_method(20,vid,num_corners,qual_corners,dist_corners,1);

% Warp frames
vid_trans = warp(vid_org,T_smud(1:380));

% Play video 5 times
play_video(vid_org,vid_trans,5);

%TT = cell2mat(T);
%Tx =  TT(1:3:end,3);
%plot(Tx)
close all
trajectory_plotter(T(1:380),T_smud(1:380))

