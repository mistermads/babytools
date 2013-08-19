function seq = baby_markov_run(T,P,statelist,endfr,x0)
% BABY_TRANSITION_RUN
%
%  Synopsis
%  ========
%
%  seq = baby_markov_run(T,P,statelist,endfr)
%  seq = baby_markov_run(T,P,statelist,endfr,x0)
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

startfr = 1;
  
if nargin<5
  x0 = [];
end

F = cumsum(P);
if ~isempty(x0)
  x = find(statelist==x0);
else
  x = min(find(rand<=F));
end

X = [1 x];
for fr=startfr+2:endfr-1
    p = T(:,x);
    F = cumsum(p);
    x1 = min(find(rand<=F));
    if x1~=x
        X = cat(1,X,[fr x1]);
        x = x1;
    end
end
seq = [X(:,1) , statelist(X(:,2))];
%seq = cat(1,[0,nan],seq);
seq = cat(1,seq,[endfr,nan]);
