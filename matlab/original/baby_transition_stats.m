function [T,P,statelist,e,CNT,Nfr] = baby_transition_stats(seq)
% BABY_TRANSITION_STATS
%
%  Synopsis
%  ========
%
%  [T,P,statelist,e,CNT,Nfr] = baby_transition_stats(seq)
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
%  seq - [frame, state; ...]
%  the duration of the last state is not included, only as a stopping point.
%
%  Outputs
%  =======
%
%  e - Number of unit eigenvalues of T. Should be 1 for sane run.

[frames,I] = sort(seq(:,1));
states = seq(I,2);
N = length(states);
Nfr = max(frames);

[unique_states,I,J] = unique(states(1:end));
M = length(unique_states);
T = zeros(M);

for n = 1:N-1
  j = J(n);
  jnext = J(n+1);
  nfr = frames(n+1) - frames(n);
  T(j,j) = T(j,j) + nfr;
  T(jnext,j) = T(jnext,j) + 1;
end
statelist = unique_states;

visited = find(sum(T>0)); % went to this state and then to something else at some point, not true for unique end-state

statelist = statelist(visited);
T = T(visited,visited);
M = length(statelist);

CNT = T;

P = diag(T);
P = P / sum(P);

for m=1:M
  T(:,m) = T(:,m) / sum(T(:,m));
end

e = find(abs(eig(T)-1)<10*eps);
