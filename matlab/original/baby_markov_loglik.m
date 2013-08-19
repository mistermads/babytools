function ll = baby_markov_loglik(O,T)
% BABY_MARKOV_LOGLIK
%
%  Synopsis
%  ========
%
%  ll = baby_markov_loglik(O,T)
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
%  Compute Markov model likelihood.
%
%  Inputs
%  ======
%
%  O - Matrix of observed transition counts.
%
%  T - Markov model transition matrix.
%
%  Outputs
%  =======
% 
%  ll - log p(O|T).

ll = sum(sum(CNT .* log(T) ));
