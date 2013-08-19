function raw_qualisys = baby_qualisys_import_missing_sds(raw_qualisys,raw_sds,sds_statenames_missing, undefnan)
% BABY_QUALISYS_IMPORT_MISSING_SDS
%
%  raw_qualisys = baby_qualisys_import_missing_sds(raw_qualisys,raw_sds,sds_statenames_missing)
%  raw_qualisys = baby_qualisys_import_missing_sds(raw_qualisys,raw_sds,sds_statenames_missing, undefnan)
%
%  set undefnan=1 to set nan in qualisys before sds starts and after it ends. Default = 0.

if nargin>=4
    undefnan = 0;
end

qs_tt = 0:length(raw_qualisys.A)-1;
qs_tt = qs_tt/raw_qualisys.HEADER.FREQUENCY;
for i = 1:length(raw_sds.states)
    if ~ismember(raw_sds.Header.statenames{raw_sds.states(i)},sds_statenames_missing), continue, end
    raw_qualisys.A(find( (qs_tt>=raw_sds.t1times(i)/1000)  & (qs_tt<raw_sds.t2times(i)/1000))) = nan;
end

if undefnan
    raw_qualisys.A(find( (qs_tt<min(raw_sds.t1times)/1000 ))) = nan;
    raw_qualisys.A(find( (qs_tt>max(raw_sds.t2times)/1000 ))) = nan;    
end
