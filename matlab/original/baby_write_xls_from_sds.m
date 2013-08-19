function baby_write_xls_from_sds(xlsfile,raw_sds)
% BABY_WRITE_XLS_FROM_SDS
%
%  Synopsis
%  ========
%
%  baby_write_xls_from_sds(xlsfile,raw_sds)

N = length(raw_sds.states);

ARR = {};
for i=1:N
    ARR{i,1} = raw_sds.Header.statenames{raw_sds.states(i)};
    ARR{i,2} = raw_sds.t1times(i);
    ARR{i,3} = raw_sds.t2times(i);
end

ARR
[SUCCESS,MESSAGE]=xlswrite(xlsfile,ARR);
if ~SUCCESS
    error(MESSAGE.message);
end
