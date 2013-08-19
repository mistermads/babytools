function raw_qualisys = baby_qualisys_import_missing_xls(raw_qualisys,xlsfile)
% BABY_QUALISYS_IMPORT_MISSING_XLS
%
% 

hh = baby_load_holdehaandxls(xlsfile);

qs_tt = 0:length(raw_qualisys.A)-1;
qs_tt = qs_tt/raw_qualisys.HEADER.FREQUENCY;
for i = 1:size(hh,1)
    if ~isnan(hh(i,3)), continue, end
    raw_qualisys.A(find( (qs_tt>=hh(i,1))  & (qs_tt<hh(i,2)))) = 0;
end
