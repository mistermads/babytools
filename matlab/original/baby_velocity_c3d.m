function [speed,velocity,unit] = baby_velocity_c3d(raw_c3d,framerate,markername,smoothpnts)
% BABY_VELOCITY_C3D
%
%  Synopsis
%  ========
%
%  [speed,velocity,unit] = baby_velocity_c3d(raw_c3d,framerate,markername)
%  [speed,velocity,unit] = baby_velocity_c3d(raw_c3d,framerate,markername,smoothpnts)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     August 2012
%
%  Purpose
%  =======
%  
%  Compute marker velocity from loaded C3D file.
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

if nargin<4, smoothpnts = 0; end
if mod(smoothpnts,2)==0
    error('Argument "smoothpnts" is not an odd number.');
end

smoothify = @smoothify_movingaverage

dt = 1/framerate;

xyz = getfield(raw_c3d,markername);

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
unit = [raw_c3d.units '/s'];

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
