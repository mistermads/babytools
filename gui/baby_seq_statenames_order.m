function [seq2,statenames2] = baby_seq_statenames_order(seq,statenames,statenames2,varargin)
% BABY_SEQ_STATENAMES_ORDER
%
% [seq2,statenames2] = baby_seq_statenames_order(seq,statenames,statenames2,{r1a,r1b,...},{r2a,r2b,...},...)

huske_replace = [];
for statenameidx = 1:length(statenames)
    statename = statenames{statenameidx};
    for j = 1:length(varargin)
        expr_j = varargin{j};
        for k = 1:length(expr_j)
            % PROBLEM with 'emptymatch'. version too old?
            S = regexp(statename,expr_j{k}); %,'emptymatch');
            if ~isempty(S)
                huske_replace = cat(1,huske_replace,[statenameidx , j]);
                break
            end
        end
    end
end

if length(unique(huske_replace(:,1))) < size(huske_replace,1)
    error('non-unique replace.');
end

seq2 = seq;
for j = 1:size(huske_replace,1)
    idx = find(seq(:,2)==huske_replace(j,1));
    seq2(idx,2) = huske_replace(j,2);
end

seq2 = baby_seq_reduce(seq2);