function seq2 = baby_seq_expand(seq)
% BABY_SEQ_EXPAND
%
%  seq_expanded = baby_seq_expand(seq)
%
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     November 2012
%
%  Purpose
%  =======
% 
%  Expand such that each frame state is explicit. This
%  makes a highly redundant (unconventional) seq which 
%  can be made conventional again by BABY_SEQ_REDUCE.

baby_seq_check(seq);

durations = baby_seq_durations(seq);

startfr = min(seq(:,1));
fr = startfr;
fr2 = startfr;

seq2 = nan(nansum(durations)-startfr,2);

idx=1;
idx2 = 1;
while 1
    d = durations(idx);
    if isnan(d), break, end % end by duration nan
    fr_lookah = fr+d;
    for fr2=fr:fr_lookah-1
        seq2(idx2,:) = [fr2 seq(idx,2)];
        idx2 = idx2 + 1;
    end
    fr = fr_lookah;
    idx = idx +1;
end
seq2(idx2,:) = [fr_lookah,nan];
