function seq = baby_seq_reduce(seq)
% BABY_SEQ_REDUCE
%
%  Synopsis
%  ========
%
%  seq = baby_seq_reduce(seq)
%
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     November 2012
%
%  Purpose
%  =======
% 
%  Remove redundant states. This is the opposite
%  of BABY_SEQ_EXPAND.

seq = nanreduce(seq);
seq = numreduce(seq);

% ---------- AUX ----------
function seq=nanreduce(seq)
rmidx = [];
for idx = 2:size(seq,1)
  if isnan(seq(idx-1,2)) & isnan(seq(idx,2)), rmidx = cat(1,rmidx,idx); end
end
seq(rmidx,:) = [];

function seq=numreduce(seq)
rmidx = [];
for idx = 2:size(seq,1)
  if (seq(idx-1,2)  == seq(idx,2)), rmidx = cat(1,rmidx,idx); end
end
seq(rmidx,:) = [];
