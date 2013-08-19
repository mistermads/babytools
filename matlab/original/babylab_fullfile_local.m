function filestr = babylab_fullfile_local(par,mdr,filetype)
% BABYLAB_FULLFILE_LOCAL
%
%  filestr = babylab_fullfile_local(par,mdr,filetype)
%
%  directory structure relative to path set in this
%  script
%
%      Lydkodninger/*M*/P*M*.txt
%
%  filetypes 
%   'lydkodning' / 'praat'

localbasepath = fullfile(getenv('HOME'),'professor/Copenhagen/data/babylab/');

filestr = [];
switch lower(filetype)
 case {'lydkodning','praat'}
  mdrdir = baby_find_file_by_numbers(fullfile(localbasepath,'Lydkodninger'),mdr);
  dirstr =   fullfile(localbasepath,'Lydkodninger',mdrdir);
  [match,matches]=baby_find_file_by_numbers(fullfile(dirstr,'*.txt'),par,mdr);
end

if ~isempty(match)
  filestr = fullfile(dirstr,match);
else
  filestr = [];
end
