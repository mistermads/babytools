function [lag,amp,SL,SA,SC1,SC2,b] = baby_video_svd_sync(U1,S1,V1,U2,S2,V2,maxlag)
% BABY_VIDEO_SVD_SYNC
%
%  Synopsis
%  ========
%
%  [lag,amp,SL,SA,SC1,SC2,b] = baby_video_svd_sync(U1,S1,V1,U2,S2,V2,maxlag)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     March 2012
%
%  Purpose
%  =======
%
%  Output
%  ======
%
%  lag - The delay of 2 relative to 1.
%
%  amp - absolute value of correlation.
%
%  SL,SA,C1,C2 - Sorted according to amp: lag,amp/b,comp1,comp2, where b
%  scales so the best correlation gets a 1.
%
%  b - the max of amp(:)

if nargin<7
  maxlag = 60;
end

N1 = size(V1,2);
N2 = size(V2,2);

lag = nan(N1,N2);
C1 = lag;
C2 = lag;

for c1=1:N1
  v1 = V1(:,c1) - mean(V1(:,c1));
  for c2=1:N2
    C1(c1,c2) = c1;
    C2(c1,c2) = c2;
    v2 = V2(:,c2) - mean(V2(:,c2));
    [C,LAGS] = xcorr(v1,v2,maxlag,'unbiased');
    [dum,idx] = max(abs(C));
    lag(c1,c2) = LAGS(idx);
    amp(c1,c2) = dum;
  end
end

b = max(amp(:));
A = amp / b;

[SA,idx] = sort(A(:),'descend');
SL = lag(idx);
SC1 = C1(idx);
SC2 = C2(idx);
