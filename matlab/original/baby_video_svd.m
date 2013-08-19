function [U,S,V,img] = baby_video_svd(x,Ncomp,dnsamp)
% BABY_VIDEO_SVD
%
%  Synopsis
%  ========
%
%  [U,S,V,img] = baby_video_svd(x)
%  [U,S,V,img] = baby_video_svd(x,Ncomp)
%  [U,S,V,img] = baby_video_svd(x,Ncomp,dnsamp)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     March 2012
%
%  Purpose
%  =======
%
%  Compute the SVD of a video.
%
%  Input
%  =====
%
%  x - Video data, see BABY_AV_EXTRACT_VIDEO
%
%  Ncomp - Number of SVD components to extract. Default 5.
% 
%  dnsamp - Factor to downsample spatially. Default 5.
%
%  Outputs
%  =======
%
%  U,S,V - The SVD.
%
%  img - Spatial basis so that image(img(:,:,:,c)) will
%  produce the spatial image of component c.

if nargin<2
  Ncomp = 5;
end
if nargin<3
  dnsamp = 5;
end

y = x(1:dnsamp:end,1:dnsamp:end,:,:);

[Y,X,W,F] = size(y);
[U,S,V] = svds(reshape(double(y),[Y*X*W,F]),Ncomp);
img = reshape(U,[Y,X,3,Ncomp]);
for c=1:Ncomp
  tmp = img(:,:,:,c);
  img(:,:,:,c) = 255*tmp / max(tmp(:));
end
img = reshape(uint8(img),[Y,X,W,Ncomp]);
