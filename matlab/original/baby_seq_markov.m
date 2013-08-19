function [T,statelist,Pinf,e,startfr,endfr] = baby_seq_markov(seq)
% BABY_SEQ_MARKOV
%
%  Synopsis
%  ========
%
%  [T,statelist,Pinf,e,startfr,endfr] = baby_seq_markov(seq)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     September 2012
%
%  [1] Sherlaw-Johnson, et al. (1995), "Estimating a Markov Transition
%  Matrix from Observational Data", The Journal of the Operational 
%  Research Society, Vol. 46
%
%  Purpose
%  =======
%
%  Estimate Markov model transition matrix by Maximum-Likelihood. Use 
%  the EM algorithm if missing values are present.
%  
%  Inputs
%  ======
%
%  seq - [frame, state; ...]
%  the duration of the last state is not included, only as a stopping point.
%  Missing values are entered as a nan-state.
%
%  Outputs
%  =======
%
%  T - State transition matrix, normalized columns. See also statelist below.
%
%  statelist - Relate state numbers to dimensions of T and P such that
%  T(i,j) refers to the transition from state statelist(i) to  state 
%  statelist(j).
%
%  Pinf - Stationary state distribution. Nan if e not equal to 1. 
%
%  e - Number of unit eigenvalues of T. Should be 1 for sane run.
%  A warning will be produced if e does *not* equal 1.
%
%  endfr - Last frame number.
%
%  startfr - First state frame number.

endfr = max(seq(:,1));
startfr = min(seq(:,1));

% remove the beginning nan in frame 0 and the nan at the end
if isnan(seq(1,2)) & seq(1,1)==0
    seq(1,:) = [];
end
if isnan(seq(end,2))
    seq(end,:) = [];
end

% look for missing values and insert a dummy
% state number instead
if any(isnan(seq(:,2)))
  nan_seq_idx = find(isnan(seq(:,2)));
  nan_statenum = max(seq(:,2)) + 1;
  seq(nan_seq_idx,2) = nan_statenum;
else
  nan_statenum = [];
end

% sort by increasing frame number
[frames,I] = sort(seq(:,1));
states = seq(I,2);
N = length(states);

% unique states
[unique_states,I,J] = unique(states(1:end));
M = length(unique_states);
T = zeros(M);
statelist = unique_states;

% count transitions on frame-by-frame basis
% loop over seq transitions
for n = 1:N-1
  j = J(n);
  jnext = J(n+1);
  nfr = frames(n+1) - frames(n);
  T(j,j) = T(j,j) + nfr;
  T(jnext,j) = T(jnext,j) + 1;
end

% look for unique end-state
visited = find(sum(T>0)); % went to this state and then to something else at some point, not true for unique end-state

% get rid of unique end-state
statelist = statelist(visited);
T = T(visited,visited);

% do EM if missing values
if ~isempty(nan_statenum)
    % get rid of dummy nan-state to get a starting guess
    nanstateidx = find(statelist==nan_statenum);
    if ~isempty(nanstateidx)
        statelist(nanstateidx) = [];
        T(nanstateidx,:) = [];
        T(:,nanstateidx) = [];
    end
    T0 = normcolsum(T); % starting guess
    % observed gap-transitions over missing regions
    tmp = {};
    for msidx = nan_seq_idx(:)'
        if ismember(msidx,[1,N]), continue, end
        tn = seq(msidx+1,1) - seq(msidx,1) + 1;
        Tn = zeros(size(T0));
        in = find(statelist==seq(msidx-1,2));
        jn = find(statelist==seq(msidx+1,2));
        Tn(in,jn) = 1;
        tmp{length(tmp)+1} = Tn;
        tmp{length(tmp)+1} = tn;
    end 
    % EM
    [T,ll,ll0] = baby_markov_sherlawjohnson1995(T0,T,1,tmp{:});
else
    fprintf('EM not necessary.\n');
    % no missing values
    M = length(statelist);
    CNT = T;
    
    P = diag(T);
    P = P / sum(P);
    
    T = normcolsum(T);
end

% spectral stuff
[V,D] = eig(T);
[tmp,tmpidx] = sort(diag(D),'descend');
V = V(:,tmpidx);
D = D(tmpidx,tmpidx);
e = find(abs(tmp-1)<10*eps);
if ~all(e==1)
  warning('Number of unit eigenvalues is not equal to one, or there are eigenvalues of larger magnitude.');
  Pinf = nan;
else
  Pinf = V(:,e);
  Pinf = Pinf / sum(Pinf);
end

% order by increasing state number
[statelist,sortidx] = sort(statelist);
T = T(sortidx,sortidx);
if ~isnan(Pinf)
    Pinf = Pinf(sortidx);
end

return

%%%%%%%%%%%%%%%%%%%%
% aux
function T = normcolsum(T)
M = size(T,1);
for m=1:M
  T(:,m) = T(:,m) / sum(T(:,m));
end
