function [seq,statenames] = baby_holdehaand_manual_xls(raw_xls,sheetname,varname,fps)
% BABY_HOLDEHAAND_MANUAL_XLS
%
%  Synopsis
%  ========
%
%  [seq,statenames] = baby_holdehaand_manual_xls(raw_xls,sheetname,varname)
%  [seq,statenames] = baby_holdehaand_manual_xls(raw_xls,sheetname,varname,fps)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     April 2013
%
%  Purpose
%  =======
% 
%  Query a 'manual holdehaand' xls sheet.
%
%  Input
%  =====
%
%  raw_xls - Get this with BABY_LOAD_XLS.
%
%  sheetname - name of the xls sheet. This spread sheet is very
%  specificly laid out, see mails of late November 2012. Snippet from
%  a sheet (row 1, any column). The snippet is found by varname='Dyade 1':
%
%   Dyade 1		
%   EKSPORTERET FRA ELAN		
%   Starttid i millisek  Sluttid i millisek      Kategori
%   0                    5819                    Empty
%   5819                 6739                    HH
%   6739                 20577                   Empty
%   20577                25940                   HH
%   25940                30917                   Empty
%
%  varname - see above, the varname would be 'Dyade 1'.
%
%  fps - Resulting seq fps.
%
%  Output
%  ======
%
%  seq - states are 1 for Empty or 2 for HH. Output frame rate is fps (default 60).

if nargin<4
    fps = 60;
end

[raw_sheet,sheetidx,varnames] = baby_query_xls(raw_xls,sheetname);

column = 0;
for vidx = 1:length(varnames)
    if ~isstr(varnames{vidx}), continue, end
    if ~isempty(regexpi(varnames{vidx},['^' varname '$']))
        column = vidx;
        break
    end
end

if ~column
    error(sprintf('The column titled ''%s'' was not found in the holdehaand xls file sheet ''%s''.',varname,sheetname));
end

tmp = raw_sheet.raw(:,column+(0:2));

seq = [];
for row = 1:size(tmp,1)
    n1 = tmp{row,1};
    n2 = tmp{row,2};
    s3 = tmp{row,3};
    if isnumeric(n1) & isnumeric(n2) & isstr(s3)
        if ~isempty(regexpi(tmp{row,3},'^HH'))
            state = 2;
        else
            state = 1;
        end
        f1 = 1+floor(fps*n1/1e3);
        f2 = 1+floor(fps*n2/1e3);
        %f2 = max(f2,f1); % at least 1 video-frames, i.e at least 2 QS frames
        seq = cat(1,seq,[f1,f2,state]);
    end
end

seq = [seq(:,[1 3]);
       seq(end,2) nan];

seq = baby_seq_reduce(seq);

statenames = {'','HH'};
