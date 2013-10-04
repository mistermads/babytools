function msec = frames2msec(frames, framerate, precision)
% FRAMES2MSEC
%
% function to convert frames into milliseconds
% Input: frames, framerate, precision
% --> precision defines the number of decimal places

msec = frames/framerate*1000;

msec = round(msec*10^precision)/(10^precision);

end
