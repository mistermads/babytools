function [x,fps,totfr] = baby_av_extract_video(avifile,frames)
% BABY_AV_EXTRACT_VIDEO
%
%  Synopsis
%  ========
%
%  [x,fps,totfr] = baby_av_extract_video(avifile,frames)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     March 2012
%
%  * Requires "mmread" from 
%    http://www.mathworks.com/matlabcentral/fileexchange/8028-mmread
%
%  Purpose
%  =======
%  
%  Exctract 

if ~exist(avifile,'file')
  error(['Video-file ' avifile ' not found.']);
end

if nargin<2
  frames=0;
end

% mmread is a little funny, so let's cd to the
% avifile to get the full path to the video
cwd_save = pwd;
[PATHSTR,NAME,EXT] = fileparts(avifile);
if ~isempty(PATHSTR) % if not in current dir
  cd(PATHSTR);
end
fullpathstr = pwd;
avifile_full = fullfile(fullpathstr,[NAME EXT]);

% read the file
video = mmread(avifile_full, frames);

if isempty(frames)
  frames = 1:length(video.frames);
end
% cd back
cd(cwd_save);

% return
x = zeros(video.height,video.width,3,length(frames),'uint8');
for frameidx=1:length(frames)
  x(:,:,:,frameidx) = video.frames(frameidx).cdata;
end
fps = video.rate;
totfr = abs(video.nrFramesTotal);
