clear all; close all;

% Video settings
vid_path = 'C:\Users\Harald\Documents\Dropbox\Studier\Semester 09\Biomedisinsk signalbehandling\matlab_work\Testvideoer\';

%JA
%current_vid = 'Colonoskopi_24064049263_20140408-1.avi';
%start_pos = 15; % where to start in seconds
%num_frames = 150;

%NEI
%current_vid = 'Colonoskopi_04034843509_20140324-1.avi';
%start_pos = 220; % where to start in seconds
%num_frames = 350;


%JA
%current_vid = 'colon2.avi';
%start_pos = 47; % where to start in seconds
%num_frames = 275;

%NEI
%current_vid = 'colon1.avi';
%start_pos = 0; % where to start in seconds
%num_frames = 400;

%NEI
%current_vid = 'colon3.avi';
%start_pos = 35; % where to start in seconds
%num_frames = 250;

%JA!!!!!
%current_vid = 'fish.avi';
%start_pos = 15; % where to start in seconds
%num_frames = 450;

%JA!!!!!
current_vid = 'hippo.mp4';
start_pos = 0; % where to start in seconds
num_frames = 400;

% Stabilization settings
full_affine = 1;
smooth_len = 50;
k = 30;

% Dynamic model         % System noise, smaller value give more smoothing
sigma_z = 0.002;        % - zoom, a2/a3
sigma_r = 0.08;         % - rotation, a1/a4
sigma_b = 0.0005;       % - translation, b1/b2
                        % Observation noise, larger value gives more smoothing
sigma_obs_z = 1;        % - zoom, a2/a3
sigma_obs_r = 1;        % - rotation, a1/a4
sigma_obs_b = 1;        % - translation, b1/b2

% Load the video
[vid_org,vid] = load_videoreader(current_vid,start_pos,num_frames);

% Estimate motion
T = motion_estimation(vid,'affine',full_affine);

% Estimate transformations for stabilization for Nghia, Matsushita, Litvin
%T_nghia = nghia_method(T,smooth_len);
T_mat = matsushita_method(T,k);
T_lit = litvin_method(T,sigma_z,sigma_r,sigma_b,sigma_obs_z,sigma_obs_r,sigma_obs_b);

% Warp frames, cropping if crop_border > 0
crop_border = 40;
vid_lit = warp(vid_org,T_lit,crop_border);
vid_mat = warp(vid_org,T_mat,crop_border);
vid_org_crop = crop(vid_org,crop_border);
%vid_nghia = warp(vid_org,T_nghia,crop_border);

% The videos to compare
vid_play1 = vid_lit;
vid_play2 = vid_mat;

% Play both videos 5 times
play_video(vid_org_crop,vid_play2,1,'compare');

% Compare two transformed videos
%play_video(vid_play1,vid_play2,5,'compare');

% Play stabilized video 2 times
%play_video(vid_org,vid_play1,1,'single');

% Plot trajectories
% Nghia 
%figure
%trajectory_plotter(T,T_nghia,'Nghia')

% Matsukisatas 
%figure
%trajectory_plotter(T,T_mat,'Matsushita')

% Litvins
%figure
%trajectory_plotter(T,T_lit,'Litvin');

trajectory_plotter_comp(T,T_lit,T_mat,2)

set(gcf,'color','w')
set(gcf, 'Position', [0 0 0.6*1600 0.6*400])

export_fig('-pdf','hippo')


%export_video(vid_lit,'hippo_lit');
%export_video(vid_mat,'hippo_mat');
%export_video(vid_org_crop,'hippo_orig');