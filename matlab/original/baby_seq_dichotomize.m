function [seq_d,statenames_d] = baby_seq_dichotomize(seq,states1,statenames)
% seq_d = baby_seq_dichotomize(seq,states1)
% [seq_d,statenames_d] = baby_seq_dichotomize(seq,states1,statenames)


states = unique(seq(find(~isnan(seq(:,2))),2));

idx1 = ismember(seq(:,2),intersect(states,states1));
idx2 = ismember(seq(:,2),setdiff(states,states1));
seq(idx1,2) = 1;
seq(idx2,2) = 2;

if nargin>2
    statenames_d{1} = strcat(statenames{states1});
    statenames_d{2} = strcat(statenames{setdiff(states,states1)});
end
seq_d = seq;
