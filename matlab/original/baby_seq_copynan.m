function seq2 = baby_seq_copynan(seq1,seq2)
% BABY_SEQ_COPYNAN
%
%  seq2 = baby_seq_copynan(seq1,seq2)
%
% seq1 - src
% seq2 - dest

seq2 = baby_seq_expand(seq2); % EXPAND!

N1 = size(seq1,1);
N2 = size(seq2,1);

startfr1 = min(seq1(:,1));
durations1 = baby_seq_durations(seq1);

startfr2 = min(seq2(:,1));
%durations2 = baby_seq_durations(seq2);

if startfr1~=startfr2
    error('The seqs must have the same startframes.');
end
startfr = startfr1;

idx1=1;
idx2=1;
fr1 = startfr;
fr2 = startfr;
%fprintf('%4i,%4i\n',fr1,fr2);

while 1
    if isnan(seq1(idx1,2))
        % copy the nan
        seq2(idx2,2) = nan;
    end
    
    % end?
    d1 = durations1(idx1);
    d2 = 1; %durations2(idx2);
    if any(isnan([d1 d2])), break, end
    
    % step
    fr1_lookah = fr1+d1;
    fr2_lookah = fr2+d2;
    if fr1_lookah==fr2_lookah
        idx1=idx1+1;
        idx2=idx2+1;
    else
        [dum,lid] = min([fr1_lookah fr2_lookah]);
        if lid==1
            idx1=idx1+1;
        else
            idx2=idx2+1;
        end
    end
    fr1 = seq1(idx1,1);
    fr2 = seq2(idx2,1);
    %    fprintf('%4i,%4i\n',fr1,fr2);
end

seq2 = baby_seq_reduce(seq2); % REDUCE!
