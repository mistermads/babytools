function seq = baby_seq_trunc(seq,maxframe)
% 

idx = find(seq(:,1)>maxframe);
if ~isempty(idx)
    seq(idx,:) = [];
    seq(min(idx),:) = [maxframe+1, nan];
end
seq = baby_seq_reduce(seq);


