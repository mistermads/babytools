function [subsheet,sheetidx,varnames,matches] = baby_query_xls(raw_xls,sheetname,varargin)
% BABY_QUERY_XLS
%
%  Synopsis
%  ========
%
%  [raw_sheet,sheetidx,varnames] = baby_query_xls(raw_xls,sheetname)
%  [raw_subsheet,sheetidx,varnames,matches] = baby_query_xls(raw_xls,sheetname,var1,val1,var2,val2,...)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     September 2012
%
%  Purpose
%  =======
% 
%  Search and pick within a loaded Excel file.
%
%  Notes
%  =====
%
%  Variable names are defined by the first row of the sheet.
%
%  String cells are mathed using regular expressions (see REGEXP).
%
%  Output
%  ======
%
%  A sheet where the rows that match all conditions are returned.
%  Variable names are included as the top row.

sheetidx = strmatch(sheetname,{raw_xls.sheetname},'exact');
if isempty(sheetidx)
    error(sprintf('The desired sheetname "%s" did not match any sheets in the xls.',sheetname));
end

subsheet = raw_xls(sheetidx);
varnames = subsheet.raw(1,:);



% query within sheet
if nargin>2    
    rowselector_intersect = [];
    for N = 1:2:length(varargin)
        
        rowselector = 1; % select row-1 with the varnames 
        
        varN = varargin{N};
        colN = strmatch(varN,varnames,'exact');
        if isempty(colN)
            error(sprintf('The variable "%s" was not found in the sheet.',varN));
        end
        valN = varargin{N+1};
        for row=2:size(subsheet.raw,1)
            [txt,num] = raw_to_txt_or_num(subsheet.raw{row,colN});

            if ~isempty(txt)
                % text cell
                if isnumeric(valN), continue, end
                S = regexp(txt,valN);
                if isempty(S), continue, end
                rowselector = cat(1,rowselector,row);
            else
                % numeric cell
                if ~isnumeric(valN), continue, end
                Q = (num == valN);
                if ~Q, continue, end
                rowselector = cat(1,rowselector,row);                
            end
        end
        if isempty(rowselector_intersect)
            rowselector_intersect = rowselector;
        else            
            rowselector_intersect = intersect(rowselector_intersect,rowselector); % intersect to match assert multiple columns
        end
    end
    matches = length(rowselector_intersect);
    rowselector = sort(union(1,unique(rowselector_intersect))); % inserted the 1 to get the variable names for compatible output
else
    matches = size(subsheet.raw,1);
    rowselector = 1:matches;
end

matches = matches - 1;
subsheet.raw = subsheet.raw(rowselector,:);


% AUX --------------------
function [txt,num] = raw_to_txt_or_num(raw)
if isnumeric(raw)
    num = raw;
else
    num = str2double(raw);
end
if isnan(num)
    txt = raw;
    if any(isnan(txt))
        txt = '';
    end
else
    txt = '';
end
if iscell(txt)
    txt = txt{1};
end
if iscell(num)
    num = num{1};
end
