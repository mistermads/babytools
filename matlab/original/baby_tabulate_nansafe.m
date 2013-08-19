function [AbB,BbA,AiB,BiA] = baby_tabulate_nansafe(seqA,stateA,seqB,stateB)
% BABY_TABULATE_NANSAFE
%
%  Synopsis
%  ========
%
%  [AbB,BbA,AiB,BiA] = baby_tabulate(seqA,stateA,seqB,stateB)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     September 2012
%
%  [1] Yale, et al. (2003), "The Temporal Coordination of Early Infant
%  Communication", Developmental Psychology, Vol. 39, No. 5, 815-824.
%
%  Purpose
%  =======

[AbB,BbA,AiB,BiA] = deal(0);

seqA = baby_seq_dichotomize(seqA,stateA); % state 1 is the unit now
seqB = baby_seq_dichotomize(seqB,stateB); % state 1 is the unit now

AiB = aux_AiB(seqA,seqB);
BiA = aux_AiB(seqB,seqA);
AbB = aux_AbB(seqA,seqB);
BbA = aux_AbB(seqB,seqA);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function AiB = aux_AiB(seqA,seqB)
% AiB
AA = find(seqA(:,2)==1);

% expand stateA in A both pre and post
seqA_c = seqA;
for n = AA'
    if isnan(seqA(n-1,2)), seqA_c(n-1,2) = 1; end
    if isnan(seqA(n+1,2)), seqA_c(n+1,2) = 1; end
end
seqA = baby_seq_reduce(seqA_c);

% shrink stateB in B both pre and post, i.e. do nothing
seqB = baby_seq_reduce(seqB);

% count
[AAonset,AAoffset] = onsetoffset(seqA);
[BBonset,BBoffset] = onsetoffset(seqB);

AiB = 0;
for n=1:length(AAonset)
    % AiB
    AiB = AiB + sum( AAonset(n)>BBonset & AAoffset(n)<BBoffset);
end

%%%%%%%%%% AbB
function AbB = aux_AbB(seqA,seqB)
% AbB
AA = find(seqA(:,2)==1);
BB = find(seqB(:,2)==1);

% expand stateA in A post
seqA_c = seqA;
for n = AA'
    if isnan(seqA(n+1,2)), seqA_c(n+1,2) = 1; end
end
seqA = baby_seq_reduce(seqA_c);

% expands stateB in B pre
seqB_c = seqB;
for n = BB'
    if isnan(seqB(n-1,2)), seqB_c(n-1,2) = 1; end
end
seqB = baby_seq_reduce(seqB_c);

% count
[AAonset,AAoffset] = onsetoffset(seqA);
[BBonset,BBoffset] = onsetoffset(seqB);

AbB = 0;
for n=1:length(AAonset)
    % AbB
    AbB = AbB + sum(AAonset(n)<BBonset & AAoffset(n)<BBoffset & AAoffset(n)>BBonset);
end

%%%%%%%%%%%%%%%%%%%%
function [AAonset,AAoffset] = onsetoffset(seqA)
AA = find(seqA(:,2)==1);
if isempty(AA)
    [AAonset,AAoffset] = deal([]);
    return
end
AAonset = seqA(AA,1);
if AAonset(1)==0, AAonset(1) = -inf; end
AAoffset = seqA(AA(1:end-1)+1,1)-1;
if AA(end,1)==size(seqA,1)
    AAoffset = [AAoffset;inf];
else
    AAoffset = [AAoffset;seqA(AA(end)+1,1)-1];
end
