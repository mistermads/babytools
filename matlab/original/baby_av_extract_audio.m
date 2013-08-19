function [x,srate] = baby_av_extract_audio(avifile,timeinterval)
% BABY_AV_EXTRACT_AUDIO
%
%  Synopsis
%  ========
%
%  [x,srate] = baby_av_extract_audio(avifile)
%  [x,srate] = baby_av_extract_audio(avifile,timeinterval)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     September 2012
%
%  * Requires "mmread" from 
%    http://www.mathworks.com/matlabcentral/fileexchange/8028-mmread
%
%  Purpose
%  =======
%  
%  Exctract 
%
%  Inputs
%  ======
%
%  timeinterval - Define by [a b] the interval between a and b 
%  seconds in the avi-file.

if nargin<2
    timeinterval = [];
end

if ~exist(avifile,'file')
  error(['Video-file ' avifile ' not found.']);
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
[video, audio] = mmread(avifile_full, [], timeinterval, true);
%timeinterval = [1 90];
%[video, audio] = mmread(avifile_full, [], timeinterval, true, false, '', [], false); % WORKS ON WIN 32BIT

% cd back
cd(cwd_save);

% return
x = audio(1).data;
srate = audio(1).rate;
