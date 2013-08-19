function [match, matches] = baby_find_file_by_numbers(dirstr,varargin)
% BABY_FIND_FILE_BY_NUMBERS
%
%  Synopsis
%  ========
%
%  [match, matches] = baby_find_file_by_numbers(dirstr,num1,num2,...)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     March 2012
%
%  Purpose
%  =======
%
%  Find a file that has a specific sequence of numbers in the filename.
%  The numbers must be separated by non-digit strings. Comparisons are
%  done numerically.
%
%  Inputs
%  ======
%
%  dirstr - The path and wildcards to select a set of candidate files.
%
%  num# - The #'th number in the filename must equal this number.
%
%  Outputs
%  =======
%
%  match - String. If only one matching filename then it is returned here, 
%  otherwise this is set to empty.
%  
%  matches - Cell array of strings with all the matched filenames.

numbers = [varargin{:}];
numbers = numbers(:);
M = length(numbers);

q = dir(dirstr);

matches = {};
for filenum=1:length(q)
  S = regexp(q(filenum).name,'\d+','match');
  if length(S)<M, continue, end
  tmp = str2double(S(1:M));
  tmp = tmp(:);
  if all(tmp==numbers)
    matches = cat(1,matches,q(filenum).name);
  end
end

if length(matches)==1
  match = matches{1};
else
  match = [];
end

