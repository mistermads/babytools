function seq = baby_seq_nanbang(seq,endfr)
% BABY_SEQ_NANBANG
%
%  seq = baby_seq_nanbang(seq)
%  seq = baby_seq_nanbang(seq,endfr)
%
%  Mar 2013

if nargin<2
    endfr = [];
end

if seq(1,1)>1
    seq = cat(1,[1,nan], seq);
end
if ~isempty(endfr)
    seq = cat(1,seq,[endfr+1 nan]);
end
seq = baby_seq_reduce(seq);
