function x = baby_av_extract_video_roi(avifile,roi)
% BABY_AV_EXTRACT_VIDEO_ROI
%
%  Synopsis
%  ========
%
%  x = baby_av_extract_video_roi(avifile,roi)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     May 2012
%
%  * Requires "mmread" from 
%    http://www.mathworks.com/matlabcentral/fileexchange/8028-mmread
%
%  Purpose
%  =======
%  
%  Exctract ROI of video.
%
%  Inputs
%  ======
%
%  roi - [x1 y1 x2 y2] - x down, y over

[x,fps,totfr] = baby_av_extract_video(avifile,1);
for fr=1:1000:totfr
    [x,fps,totfr] = baby_av_extract_video(avifile,fr);
    image(x);
    drawnow
end