function durations=baby_seq_durations(seq)
% BABY_SEQ_DURATIONS
%
%  Synopsis
%  ========
%
%  durations = baby_seq_durations(seq)
%
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     March 2012

durations=[diff(seq(:,1));nan];
