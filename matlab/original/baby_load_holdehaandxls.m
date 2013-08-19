function hh = baby_load_holdehaandxls(xlsfile)
% BABY_LOAD_HOLDEHAANDXLS

[NUMERIC,TXT,RAW] = xlsread(xlsfile);

hh = [];
for cc = 1:size(TXT,1)
    t1 = time2sec(TXT{cc,3});
    t2 = time2sec(TXT{cc,4});
    str = TXT{cc,5};
    if strcmp(str,'None') state = 1; else state = nan; end
    hh = cat(1,hh,[t1,t2,state]);
end


% aux
function ts = time2sec(str)
S = regexp(str,':','split');
ts = (str2double(S{1})*60 + str2double(S{2}))*60 + str2double(S{3});
