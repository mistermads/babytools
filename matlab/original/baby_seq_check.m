function baby_seq_check(seq)
% BABY_SEQ_CHECK
%
%  Synopsis
%  ========
%
%  baby_seq_check(seq)
%
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     November 2012
%
%  Purpose
%  =======
%
%  Throw error if seq does not follow the convention.
%
%  Input / Convention
%  ==================
%
%  seq - An N-by-2 matrix which has frame numbers in the first
%  column and state number in the second column. Only state transitions
%  should be defined (except for a potentially redundant but necessary
%  NaN-state in frame one). NaN can be used instead of state numbers 
%  to denote missing data. The first frame is always frame one. The
%  last frame is always a NaN-state. States before frame one are
%  assumed missing. Frames can never be zero or negative. Example:
%
%  seq = 
%           1           1
%         471           2
%         560           1
%         579           2
%         602           1
%         685           2
%         750         NaN 
%
%  And if we delay that by, say 10 frames using BABY_SEQ_DELAY(seq,10),
%  we get...
%
%  seq =       
%           1         NaN
%          11           1
%         481           2
%         570           1
%         589           2
%         612           1
%         695           2
%         760         NaN

assert(size(seq,2)==2,'seq must have two columns.');
assert(min(seq(:,1))>0,'Frames must be positive.');
assert(seq(1,1)==1,'Frame-one is undefined.');
assert(isnan(seq(end,2)),'seq must end with a nan-state.');
assert(issorted(seq(:,1)) & ~any(seq(1:end-1,1)==seq(2:end,1)),'frame numbers must be strictly increasing.');
