function seqnan = baby_seq_nan_by(seq,seqby,bystate)
% BABY_SEQ_NAN_BY
%
%  Synopsis
%  ========
%
%  seqnan = baby_seq_nan_by(seq,seqby,bystate)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     April 2013
%
%  Purpose
%  =======
%
%  Put nans in seq based on another seq (seqby). Defined state numbers
%  (bystate) in the other seq will produce nans in the first seq. Nan is
%  allowed as a bystate, but you have to be explicit about it.

baby_seq_check(seq);
baby_seq_check(seqby);

expseq = baby_seq_expand(seq);

byidx = find(ismember(seqby(:,2),bystate));
if any(isnan(bystate))
    byidx = cat(1,byidx,find(isnan(seqby(:,2))));
end

for bi = 1:length(byidx)
    byfr1 = seqby(byidx(bi),1);
    if byidx(bi)+1 <= size(seqby,1)
        byfr2 = seqby(byidx(bi)+1,1);
    else
        byfr2 = inf;
    end
    expidx = find( (expseq(:,1)>=byfr1) & (expseq(:,1)<byfr2) );
    expseq(expidx,2) = nan;
end

seqnan = baby_seq_reduce(expseq);
