function [seq,statenames] = baby_seq_praat(raw_or_filename,varname,varargin)
% BABY_SEQ_PRAAT
%
%  Synopsis
%  ========
%
%  [seq,statenames] = baby_seq_praat(raw_praat,varname,options)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     September 2012
%
%  Purpose
%  =======
%  
%  Inputs
%  ======
%
%  raw_praat - Get this from the BABY_LOAD_PRAAT. Alternatively
%  give the filename of a praat txt-file.
%
%  varname - Name of praatfile variable, e.g. 'Barn'.
%
%  options - Options pairs  STR,PAR
%
%    STR    |  Description
%  ---------+-------------------------------------
%    'fps'  |  Set frame rate to PAR
%  
%  Outputs
%  =======
%
%  seq - 

if ischar(raw_or_filename)
  raw_praat = baby_load_praat(filename);
else
  raw_praat = raw_or_filename;
end

idx = 0;
for dum = 1:length(raw_praat.VARNAMES)
  if strcmp(lower(raw_praat.VARNAMES{dum}),lower(varname))
    idx = dum;
    break;
  end
end
if idx == 0
  error(['Could not find a variable named ' varname ' in the praat data.']);
end

for nopt = 1:2:length(varargin)
  switch lower(varargin{nopt})
   case 'fps'
    par = varargin{nopt+1};
    seq = [1+round(raw_praat.A{idx}{1}(:,1)*par) , raw_praat.A{idx}{1}(:,3)]; %1+ because frame 1 is at time 0
    endfr = round((raw_praat.A{idx}{1}(end,1)+raw_praat.A{idx}{1}(end,2))*par);
    %seq = cat(1,seq,[1+round((raw_praat.A{idx}{1}(end,1)+raw_praat.A{idx}{1}(end,2))*par) nan]);
    seq = baby_seq_nanbang(seq,endfr);
    break
   otherwise
    error(['Unknown option ' varargin{nopt}]);
  end
end

statenames = raw_praat.A{idx}{2};



