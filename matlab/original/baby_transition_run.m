function seq = baby_transition_run(T,P,statelist,Nfr,x0)
% BABY_TRANSITION_RUN
%
%  Synopsis
%  ========
%
%  seq = baby_transition_run(T,P,statelist,Nfr)
%  seq = baby_transition_run(T,P,statelist,Nfr,x0)
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
%  
%  Inputs
%  ======
%
%  P - Init probabilities.
%
%  T - Transition probabilities.
%
%  statelist - 
% 
%  x0 - init state.

if nargin<=4
  x0 = [];
end

F = cumsum(P);
if ~isempty(x0)
  x = find(statelist==x0);
else
  x = min(find(rand<=F));
end
X = [1,x];

for fr=2:Nfr
  p = T(:,x);
  F = cumsum(p);
  x1 = min(find(rand<=F));
  if x1~=x
    X = cat(1,X,[fr x1]);
    x = x1;
  end
end

seq = [X(:,1) , statelist(X(:,2))];
