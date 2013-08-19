function [ms,y1,y2,CORFS] = baby_audio_sync(x1,srate1,x2,srate2)
% BABY_AUDIO_SYNC
%
%  Synopsis
%  ========
%
%  [ms,y1,y2,CORFS] = baby_audio_sync(x1,srate1,x2,srate2)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     February 2013
%
%  Purpose
%  =======
%
%  Cross correlate to audio signals. Return the lag in milliseconds.
%  The correlation is done at 16kHz sample rate after upsampling both
%  signals to a common high sampling rate (which is automatically 
%  determined), then downsampled.
%
%  Inputs
%  ======
%
%  x1,x2 - Audio vector 1 and 2.
%
%  srate1,srate2 - Sampling rate of vectors x1 and x2 respectively.
%
%  Output
%  ======
%
%  ms - Milliseconds lag between x1 and x2. ms is negative if x1 is
%  early compared to x2. Here "early" means that the recording was
%  started *later* and therefore the events occur earlier in the recording.
%  The maximum allowed absolute lag is 100 seconds.

if ~isvector(x1) | ~isvector(x2)
  error('Audio inputs must be vectors');
end

commondiv = gcd(srate1,srate2);

P1 = srate2 / commondiv
P2 = srate1 / commondiv

TMPFS = P1 * srate1;

Q = ceil(TMPFS / 16e3);

CORFS = TMPFS / Q

y1 = resample(double(x1(:)),P1,Q);
y2 = resample(double(x2(:)),P2,Q);

% max 100 sec lag
MAXLAG = 100*CORFS;
[C,lags] = xcorr(y1,y2,MAXLAG); %,'unbiased');

% return
[tmp,idx] = max(C);
lag = lags(idx);
ms = 1e3 * lag / CORFS;
