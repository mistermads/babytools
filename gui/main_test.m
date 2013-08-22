% Test Script for Input routine from .mat-file
close all, clear all;

% path to the original babytools
addpath('../matlab/original/');

% C3D Qualisys
%[raw_c3d,markernames,units] = baby_load_c3d(FETCH_c3dfil);
fname = 'N30_04';
matraw = load(['../data/' fname]);  
eval(['matraw = matraw.' fname]);
fps = 60;
markerindex = 2;    % 1...32 
smoothpnts = 5;
speed = aux_velocity(matraw,fps,markerindex,smoothpnts);

% NOTE
% IGNORE for now! correction factor for miscalibrated data
% wand = FETCH_wand;
% speed = speed / wand;
raw_qualisys = baby_qualisys_speed(speed);


% USER params: set default here
minvelocity = 8;      % default: 200
minpauseframes = 12;
minpeaksinunit = 1;
minunitframes = 12;
% %seq_qs = baby_velocitypeaks(raw_qualisys,minvelocity,minpauseframes,minpeaksinunit,minunitframes); % states: 1:false, 2:true
 [seq_qs,qs_statenames] = baby_velocitypeaks(raw_qualisys,minvelocity,minpauseframes,minpeaksinunit,minunitframes);
 [seq_qs,qs_statenames] = baby_seq_statenames_order(seq_qs,qs_statenames,{'','x'},{'^\s*$'},{'[xX]'});
