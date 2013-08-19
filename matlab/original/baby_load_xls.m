function raw_xls = baby_load_xls(filename)
% BABY_LOAD_XLS
%
%  Synopsis
%  ========
%
%  raw_xls = baby_load_xls(filename)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     September 2012
%
%  Purpose
%  =======
% 
%  Load all the sheets from an Excel file. 

[status,sheets] = xlsfinfo(filename);

if isempty(status)
    error(['The file can not be opened. Perhaps the wrong Excel file format. Try saving the file from Excel as an older ' ...
           'format version.']);
end

raw_xls = [];

for sheetidx = 1:length(sheets)
    sheetname = sheets{sheetidx};
    fprintf('Loading sheet %s\n',sheetname);
    warning off
    [NUMERIC,TXT,RAW]=xlsread(filename,sheetname);
    warning on
    raw_xls(sheetidx).sheetname = sheetname;
    %raw_xls(sheetidx).numeric = NUMERIC;
    % raw_xls(sheetidx).txt = TXT;
    %raw_xls(sheetidx).varnames = TXT{1,:};
    raw_xls(sheetidx).raw = RAW;    
end


