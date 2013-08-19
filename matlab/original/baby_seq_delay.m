function seq_delayed = baby_seq_delay(seq,frames)
% BABY_SEQ_DELAY
%
%  Synopsis
%  ========
%
%  seq_delayed = baby_seq_delay(seq,frames)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     September 2012
%
%  Purpose
%  =======
%
%  Delay a seq.
%
%  Inputs
%  ======
%
%  frames - The number of frames to delay. Must not be negative.

baby_seq_check(seq);

if frames<0
    error('Delay can not be negative');
end
if frames==0
    seq_delayed = seq;
    return
end

if frames<0
  error('Delays must not be negative.');
end
seq_delayed = seq;
if frames>0
  seq_delayed(:,1) = round(seq_delayed(:,1) + frames);
end

seq_delayed = cat(1,[1,nan], seq_delayed);
seq_delayed = baby_seq_reduce(seq_delayed);
