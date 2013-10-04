function [seq_qs,statenames, peakcenters, dipcenters] = baby_velocitypeaks(raw_qualisys,minvelocity,minpauseframes,minpeaksinunit,minunitframes)
% BABY_VELOCITYPEAKS
%
%  Synopsis
%  ========
%
%  [seq,statenames] = baby_velocitypeaks(raw_qualisys,minvelocity,minpauseframes,minpeaksinunit,minunitframes)
%
%   -- Author: Jan Bruemmerstedt --
%      Department of Psychology, University of Copenhagen, Denmark.
%      August 2013
%
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     September 2012
%
%  Purpose
%  =======
%
%  Detects velocity units according to four criteria (in order of impact): 
%  Minimum velocity, minimum pause between units, minimum unit duration, 
%  minimum number of peaks within the unit.
%
%  Inputs
%  ======
%
%  raw_qualisys - Get this with BABY_LOAD_QUALISYS
%
%  minvelocity - Minimum velocity for candidate unit (in qualisys units, mm/s).
%
%  minpauseframes - Pauses between candidate units are removed if duration is less
%  than this.
%
%  minpeaksinunit - The minimum number of peaks in a unit.
%
%  minunitframes - The minimum duration of a unit.
%
%  Output
%  ======
%
%  seq - Units are state 2, pauses state 1, missing values are left unaltered.

seq_qs = baby_seq_qualisys(raw_qualisys,'geq',minvelocity); % velocity threshold 200
durations = baby_seq_durations(seq_qs);
% minimum pause
pausekillidx = find(durations<minpauseframes & seq_qs(:,2)==0);
seq_qs(pausekillidx,:) = [];
seq_qs = baby_seq_reduce(seq_qs);
% find peaks
q1=diff([nan;raw_qualisys.A]);
q2=flipud(diff([nan;flipud(raw_qualisys.A(:))]));
peakcenter = (sign(q1)+sign(q2))==2;
peakcenters = find(peakcenter);
% ...and dips
dipcenter = (sign(q1)+sign(q2))==-2;
dipcenters = find(dipcenter);
% minimum number of peaks in unit
idx1 = find(seq_qs(:,2)==1);
killidx = [];
for i=idx1'
  if i==size(seq_qs,1), break, end
  numpeaks = sum(peakcenters>=seq_qs(i,1) & peakcenters<seq_qs(i+1,1));
  if numpeaks<minpeaksinunit
    killidx = cat(1,killidx,i);
  end
end
seq_qs(killidx,:) = [];
seq_qs = baby_seq_reduce(seq_qs);
% minimum unit duration
durations = baby_seq_durations(seq_qs);
idx=find(durations<minunitframes & seq_qs(:,2)==1);
seq_qs(idx,:) = [];
seq_qs = baby_seq_reduce(seq_qs);

% output
seq_qs(:,2) = seq_qs(:,2) + 1; % states 1 and 2
statenames = {'','x'};
