function [AbB,BbA,AiB,BiA] = baby_tabulate(seqA,stateA,seqB,stateB)
% BABY_SEQ_PAIR_STATS
%
%  Synopsis
%  ========
%
%  [AbB,BbA,AiB,BiA] = baby_tabulate(seqA,stateA,seqB,stateB)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     January 2012
%
%  [1] Yale, et al. (2003), "The Temporal Coordination of Early Infant
%  Communication", Developmental Psychology, Vol. 39, No. 5, 815-824.
%
%  Purpose
%  =======

[AbB,BbA,AiB,BiA] = deal(0);

AA = find(ismember(seqA(1:end-1,2),stateA));
BB = find(ismember(seqB(1:end-1,2),stateB));

AAonset = seqA(AA,1);
AAoffset = seqA(AA+1,1)-1;

BBonset = seqB(BB,1);
BBoffset = seqB(BB+1,1)-1;

for n=1:length(AAonset)
  AbB = AbB + sum(AAonset(n)<BBonset & AAoffset(n)<BBoffset & AAoffset(n)>BBonset);
  BbA = BbA + sum(BBonset<AAonset(n) & BBoffset<AAoffset(n) & BBoffset>AAonset(n));
  AiB = AiB + sum(AAonset(n)>BBonset & AAoffset(n)<BBoffset);
  BiA = BiA + sum(BBonset>AAonset(n) & BBoffset<AAoffset(n));
end
