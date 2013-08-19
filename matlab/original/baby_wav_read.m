function [x,srate] = baby_wav_read(wavfile)
% BABY_WAV_READ
%
%  Synopsis
%  ========
%
%  [x,srate] = baby_wav_read(wavfile)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     March 2012
%
%  Purpose
%  =======
%
if ~exist(wavfile,'file')
  error(['Wav-file ' wavfile ' not found.']);
end

[Y,FS,NBITS]=wavread(wavfile);

srate = FS;
x = Y;
