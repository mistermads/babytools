function [raw_sds] = baby_load_sds(filename)
% BABY_LOAD_SDS
%
%  Synopsis
%  ========
%
%  raw_sds = baby_load_sds(filename)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     August 2012
%
%  Purpose
%  =======
%  
%  Inputs
%  ======
% 
%  Outputs
%  =======

fid = fopen(filename);
linenum = 0;
inheader = 1;
Q = [];
raw_sds.states = [];
raw_sds.t1times = [];
raw_sds.t2times = [];
raw_sds.Header = [];
while 1
    linenum = linenum + 1;
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    % in header?
    if isempty(tline), inheader = 0; continue, end
    % parse header
    if inheader==1
        M = regexp(tline,'(\d\w+\s){0,}\d\w+;$');
        if ~isempty(M)
            Q = regexp(tline,'\d\w+','match');
            raw_sds.Header.statenames = Q;
        end
    else % parse data
        if isempty(Q)
            error('BABYTOOLS: Did not find states in the header.');
        end        
        state = regexp(tline,'^[d\w]+','match');
        raw_sds.states(end+1) = strmatch(state{1},Q,'exact');
        times = regexp(tline,'\d\d:\d\d:\d\d\.\d\d\d','match');
        raw_sds.t1times(end+1) = timestr2ms(times{1});
        raw_sds.t2times(end+1) = timestr2ms(times{2});
    end
end
fclose(fid);

% aux
function ms = timestr2ms(str)
E = regexp(str,':','split');
ms = 1000*(60*(60*str2num(E{1}) + str2num(E{2})) + str2double(E{3}));
