function seq = baby_seq_qualisys(raw_or_filename,varargin)
% BABY_SEQ_QUALISYS
%
%  Synopsis
%  ========
%
%  seq = baby_seq_qualisys(raw_qualisys,options)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     September 2012
%
%  Purpose
%  =======
%
%  Create a seq from Qualisys data.
%
%  Inputs
%  ======
%
%  raw_qualisys - Get this from the BABY_LOAD_QUALISYS. Alternatively
%  give the filename of a tsv-file.
%
%  options - Options pairs  str,par for logical operation
%
%    STR      |  Description
%  -----------+-------------------------------------
%    'eq'     | = par
%    'geq'    | >= par
%
%  Options for extra output
%
%    'peak'   | peak, par gives the peak model:
%             |   1 - simplest
%    'min_pause'
%    'min_duration'
%
%  Examples
%
%    'peaks1' | cf. mail from Simo d. 18MAR2012
%             | par1 - lower velocity limit (mm/s)
%             | par2 - minimum number of peaks per unit
%             | par3 - minumum unit duration (s)
%             | par4 - minimum pause between units
%  
%  Outputs
%  =======
%
%  seq - 

if ischar(raw_or_filename)
  raw_qualisys = baby_load_qualisys(filename);
else
  raw_qualisys = raw_or_filename;
end

% nan model
nanmodel=0;
switch raw_qualisys.HEADER.DATA_INCLUDED
 case 'Velocity'
  nanmodel = 1;
 otherwise
  warning('Unknown measure included in the Qualisys data.');
end

% nans
if nanmodel==1
  idx0 = find(raw_qualisys.A==0);
  raw_qualisys.A(idx0) = nan;
end
nanidx=find(isnan(raw_qualisys.A));

%
states = {};
% make states
for nopt = 1:2:length(varargin)
  par = varargin{nopt+1};
  switch lower(varargin{nopt})
   case 'geq'
    tmp = double(raw_qualisys.A>=par);
    tmp(nanidx) = nan;
   case 'eq'
    tmp = double(raw_qualisys.A==par);
    tmp(nanidx) = nan;
   case 'peak'
    q1=diff([nan;raw_qualisys.A]);
    q2=flipud(diff([nan;flipud(raw_qualisys.A(:))]));
    peakcenter = (sign(q1)+sign(q2))==2;
    states = double(peakcenter);
   otherwise
    error(['Unknown option ' varargin{nopt}]);
  end
  statenum = length(states)+1;
  states{statenum} = tmp;
end

filteredstates = 1;
for statenum=1:length(states)
  filteredstates = filteredstates.*states{statenum};
end

seq = [1 ;
       1+ find(diff(filteredstates)~=0)];
filteredstates = filteredstates(seq);
seq = [seq , filteredstates ];

seq = baby_seq_nanbang(seq,raw_qualisys.HEADER.NO_OF_FRAMES);
