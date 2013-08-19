function [picks,direrr,subfilepath] = baby_filefind(filepath,fname,fext,varargin)
% BABY_FILEFIND
%
%  Synopsis
%  ========
% 
%  [picks,direrr,subfilepath] = baby_filefind(filepath,fname,fext)
%  [picks,direrr,subfilepath] = baby_filefind(filepath,fname,fext,subdir1,subdir2,...)
%
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     January 2013
%
%  Purpose
%  =======
%
%  Descend into directory structure using regular expression matching.
%  Find a particular file at the end of the search.
%
%  Inputs
%  ======
%
%  filepath - Base folder. No matching done.
%
%  fname - RegExp to match the filename (without extension). The matching 
%  is case insensitive.
%
%  fext - Same as fname, but for the extension instead of the filename.
%
%  dirN - The N'th level regular expressions to find a dir to descend into.
%
%  Output
%  ======
%
%  picks - A cell array of full filenames and path of a matching subdir+filename+ext.
%
%  direrr - Flag. Set to 1 if one of the subdir could not be found.

direrr=0;

fullfilepath = filepath;
subfilepath = '';

for level = 1:length(varargin)
    levelN_arg = varargin{level};
    q=dir(fullfile(fullfilepath,'*'));
    tmp = '';
    direrr = 1;
    for qidx = 1:length(q)
        if ~q(qidx).isdir, continue, end
        S = regexpi(q(qidx).name,levelN_arg,'match');
        if isempty(S), continue, end
        subfilepath = fullfile(subfilepath,q(qidx).name);
        fullfilepath = fullfile(fullfilepath,q(qidx).name);
        direrr = 0;
        break
    end
    if direrr==1
        break
    end
end

% some directory was not matched
picks = {};
if direrr==1
    return
else
    % get files in the dir
    filename = '';
    q=dir(fullfile(fullfilepath,'*'));
    for qidx = 1:length(q)
        if q(qidx).isdir, continue, end
        [dummy,NN,EE] = fileparts(q(qidx).name);
        EE = strrep(EE,'.','');
        SNN = regexpi(NN,fname,'match');
        SEE = regexpi(EE,fext,'match');
        if ~isempty(SNN) & ~isempty(SEE)
            filename = [NN '.' EE];
            picks{end+1} = filename; %fullfile(fullfilepath,filename);
        end
    end 
end

