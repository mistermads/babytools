function [speed,velocity,unit] = aux_velocity(raw_mat,framerate,markerindex,smoothpnts)
% AUX_VELOCITY
%
%  Synopsis
%  ========
%
%  [speed,velocity,unit] = aux_velocity(raw_mat,framerate,markerindex)
%  [speed,velocity,unit] = aux_velocity(raw_mat,framerate,markerindex,smoothpnts)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     August 2012
%
%  Purpose
%  =======
%  
%  Compute marker velocity from loaded MAT file.
%
%  Inputs
%  ======
%
%  smoothpnts - Set greater than 1 to smoothify. The total number 
%  of abcissa points to each smoother operation. Must be an odd number.
%
%  Note
%  ====
%
%  Smoothing set to emulate Qualisys 'second order curve' smoothing. Not 
%  working around missing values yet.

% NOTE: 'units' not stated, assumed to be 'mm' here
raw_mat_units = 'mm';

if nargin<4, smoothpnts = 0; end
if mod(smoothpnts,2)==0
    error('Argument "smoothpnts" is not an odd number.');
end

smoothify = @smoothify_movingaverage;

dt = 1/framerate;

% load markerdata
% NOTE: only loads labeled data so far, ignores all other!
xyz = raw_mat.Trajectories.Labeled.Data(markerindex, 1:3, :);
% reformating the matrix from 1 x 3 x length_of_data to length_of_data x 3
xyz = permute(xyz, [3 2 1]);

if smoothpnts>1
    prepost = floor(smoothpnts/2);
    xyz(:,1) = smoothify(xyz(:,1),prepost);
    xyz(:,2) = smoothify(xyz(:,2),prepost);
    xyz(:,3) = smoothify(xyz(:,3),prepost);
else
    prepost = 0;
end

N = size(xyz,1);
velocity = nan(N,3);
for idx = 2:N-1
    velocity(idx,:) = ( xyz(idx+1,:) - xyz(idx-1,:) ) / (2*dt);
end
speed = sqrt(sum(velocity.^2,2));
unit = [raw_mat_units '/s'];

if prepost
    speed = smoothify(speed,prepost);
end

return

% aux
function xx = smoothify_2ndorder(x,prepost)
tt = linspace(-1,1,5)';
C = [tt.^0, tt.^1, tt.^2];
xx = nan(size(x));
for i=(1+prepost):length(x)-prepost
    v = x(i+(-prepost:prepost));
    c = C\v;
    xx(i) = c(1);
end


function xx = smoothify_movingaverage(x,prepost)
xx = nan(size(x));
for i=(1+prepost):length(x)-prepost
    v = x(i+(-prepost:prepost));
    xx(i) = mean(v);
end
% impute gap edges
di = diff(isnan(xx));
gapl = find(di==1); % last filtered sample on left side of gap
for gl = gapl'
    impute_idx = gl+(1:prepost);
    xx(impute_idx) = x(impute_idx);
end
gapr = find(di==-1)+1; % do. on right side of gap
for gr = gapr'
    impute_idx = gr+(-prepost:-1);
    xx(impute_idx) = x(impute_idx);
end
