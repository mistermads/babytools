function [T,ll,ll0] = baby_markov_sherlawjohnson1995(T0,varargin)
% BABY_MARKOV_SHERLAWJOHNSON1995
%
%  Synopsis
%  ========
%
%  [T,ll] = baby_markov_sherlawjohnson1995(T0,Ot1,t1,Ot2,t2,...)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     March 2012
%
%  [1] Sherlaw-Johnson, et al. (1995), "Estimating a Markov Transition
%  Matrix from Observational Data", The Journal of the Operational 
%  Research Society, Vol. 46
%
%  Purpose
%  =======
%
%  Estimate Markov transition matrix from observed data with missing
%  values. The estimation is iterative using EM.
%
%  Inputs
%  ======
%
%  T0 - Initial transition matrix.
%
%  Ot# - Observed count of transitions over t# steps.
%
%  Output
%  ======
%
%  T - Estimated transition matrix.
%
%  ll - log likelihood.

maxiter = 100;

ll0=loglik(T0,varargin{:});
ll1 = ll0;
fprintf('Init,\t\tloglik=%f\n',ll0);
T = T0;
for iter=1:maxiter
  % E
  S=0;
  for iarg = 1:2:length(varargin)
    Ot = varargin{iarg};
    t = varargin{iarg+1};
    % for one value of t
    S_1t = eq8_1t(Ot,t,T);
    S = S + S_1t;
  end
  % M
  T = S;
  for k=1:size(T,1)
    T(:,k) = T(:,k) / sum(T(:,k));
  end
  % ll
  ll=loglik(T,varargin{:});
  fprintf('Iteration %i,\tloglik=%f\n',iter,ll);
  if ll-ll1<1e-8, break, end
  ll1 = ll;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function P_k = eq6(T,m,n,t,k)
%  k=0 is the step into missing region
%  k=t-1 is the step out of missing region
M = size(T,1);
Tt = T^t;
Tk = T^k;
Ttk1 = T^(t-k-1);
P_k = repmat(Tk(m,:)',[1,M]) .* T .* repmat(Ttk1(:,n)',[M,1]) / Tt(m,n);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function S = eq8_1t(O,t,T)
M = size(T,1);
% eq8
S = 0;
for m=1:M
  for n=1:M
    for k=0:t-1
      S = S + O(m,n) * eq6(T,m,n,t,k);
    end
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ll = loglik(T,varargin)
%  Compute Markov model likelihood
ll = 0;
for iarg = 1:2:length(varargin)
  Ot = varargin{iarg};
  t = varargin{iarg+1};
  ll = ll + sum(sum(Ot .* log(T^t) ));
end
