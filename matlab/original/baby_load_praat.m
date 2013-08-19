function [raw_praat,VARNAMES,A,Nignored] = baby_load_praat(filename)
% BABY_LOAD_PRAAT
%
%  Synopsis
%  ========
%
%  raw_praat = baby_load_praat(filename)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     April 2013
%
%  Purpose
%  =======
%  
%  NB. units smaller than 10ms+eps will be ignored.
%
%  Inputs
%  ======
% 
%  Outputs
%  =======

Nignored = 0;
fid = fopen(filename);
linenum = 0;
while 1
  linenum = linenum + 1;
  tline = fgetl(fid);
  if ~ischar(tline), break, end
  pattern = '[\t]';
  R = regexp(tline,pattern,'split');
  if linenum==1
    VARNAMES = {};
    for cc=2:3:length(R)
      tmp = regexp(R{cc},'_','split');
      if length(tmp)>1
        VARNAMES{end+1} = tmp{2};
      end
    end
    for varnum=1:length(VARNAMES)
      tmpout{varnum}{1} = [];
      tmpout{varnum}{2} = {};
    end
  else
    casenum = str2double(R{1});
    if isempty(casenum), break, end
    for varnum=1:length(VARNAMES)
      cc = 2+3*(varnum-1);
      t = R{cc};
      if isempty(t), continue, end
      d = R{cc+1};
      dnum = str2double(d);
      if dnum<=(1/60)+eps, Nignored=Nignored+1; continue, end
      l = R{cc+2};
      tnum = str2double(t);
      if isnan(tnum), continue, end
      tmpout{varnum}{1}(end+1,1) = tnum;
      tmpout{varnum}{1}(end,2) = str2double(d);
      statestmp = tmpout{varnum}{2};
      strcmp(statestmp,l);
      if ~any(strcmp(statestmp,l))
        statestmp{end+1} = l;
        tmpout{varnum}{2} = statestmp;
      end
      tmpout{varnum}{1}(end,3) = find(strcmp(statestmp,l));
    end
  end
end
fclose(fid);

A = tmpout;

%A_praat = dataset(tmpout{:},'VarNames',VARNAMES);

raw_praat = [];
raw_praat.VARNAMES = VARNAMES;
raw_praat.A = A;
