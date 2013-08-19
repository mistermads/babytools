function [huske,huske_big] = baby_video_sync(videofile1,videofile2)
% BABY_VIDEO_SVD_SYNC
%
%  Synopsis
%  ========
%
%  huske = baby_video_sync(videofile1,videofile2)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     March 2012
%
%  Purpose
%  =======
%
%  Synchronize two videos via SVD.

chunksize_sec = 20;
maxlag_sec = 2;
stepsize_sec = 1000;

Ncomp = 10;
dnsamp = 5;

huske = [];
huske_big  = {};
[dum,fps1,totfr1] = baby_av_extract_video(videofile1,1);
fprintf('Video-1:\t%4.1f fps,\t%i frames\n',fps1,totfr1);
[dum,fps2,totfr2] = baby_av_extract_video(videofile2,1);
fprintf('Video-2:\t%4.1f fps,\t%i frames\n',fps2,totfr2);
fps = max(fps1,fps2);
chunksize = round(chunksize_sec * fps);
fprintf('Chunksize:\t%4.1f s,  \t%i frames\n',chunksize_sec,chunksize);
maxlag = round(maxlag_sec * fps);
fprintf('Corr. maxlag:\t%4.1f s,  \t%i frames\n',maxlag_sec,maxlag);
stepsize = round(stepsize_sec * fps);
fprintf('Stepsize:\t%4.1f s,  \t%i frames\n',stepsize_sec,stepsize);
totfr = min(totfr1,totfr2);
for chunk = 1:stepsize:totfr-chunksize-10
  fprintf('%i ',chunk);
  [x,fps,totfr] = baby_av_extract_video(videofile1,chunk+(1:chunksize));
  x = double(x);
  mu = mean(x,4);
  for fr=1:chunksize
    x(:,:,:,fr) = x(:,:,:,fr) - mu;
  end
  [U1,S1,V1,img1] = baby_video_svd(x,Ncomp,dnsamp);
  [x,fps,totfr] = baby_av_extract_video(videofile2,chunk+(1:chunksize));
  x = double(x);
  mu = mean(x,4);
  for fr=1:chunksize
    x(:,:,:,fr) = x(:,:,:,fr) - mu;
  end
  [U2,S2,V2,img2] = baby_video_svd(x,Ncomp,dnsamp);
  [lag,amp,SL,SA,SC1,SC2] = baby_video_svd_sync(U1,S1,V1,U2,S2,V2,maxlag);
  huske_big = cat(2,huske_big,{SL,SA,SC1,SC2});
  bestlag=SL(1);
  margin = SA(1)/max(SA(find(SL~=bestlag)));
  huske = cat(2,huske,[bestlag;margin]);
end
fprintf('\n');
