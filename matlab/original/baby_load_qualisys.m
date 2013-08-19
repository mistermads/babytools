function [raw_qualisys,HEADER,A] = baby_load_qualisys(filename)
% BABY_LOAD_QUALISYS
%
%  Synopsis
%  ========
%
%  raw_qualisys = baby_load_qualisys(filename)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     May 2012
%
%  Purpose
%  =======
%  
%  Load in a tsv-file that was exported from Qualisys.
%
%  Inputs
%  ======
%
%  filename - Name of tsv file to load.
% 
%  Outputs
%  =======
%
%  raw_qualisys.HEADER - Information from the tsv header.
%
%  raw_qualisys.A - The matrix of numerical data.

% open file
fid = fopen(filename);
% read the header
HEADER = [];
while 1
  tline = fgetl(fid);
  if ~ischar(tline) | isempty(tline), break, end
  pattern = '[\t]';
  R = regexp(tline,pattern,'split');
  R{2} = cat(2,R{2:end});
  tmp = str2double(R{2});
  if isnan(tmp)
    tmp = R{2};
  end
  HEADER = setfield(HEADER,R{1},tmp);
end
% read the body
A = nan(HEADER.NO_OF_FRAMES,1);
frame = 0;
while 1
  tline = fgetl(fid);
  if ~ischar(tline), break, end
  if isempty(tline), continue, end
  frame = frame + 1;
  R = regexp(tline,'\t','split');
  for col=1:length(R)
      A(frame,col) = str2double(R{col});
  end
end
% close file
fclose(fid);

raw_qualisys = [];
raw_qualisys.HEADER = HEADER;
raw_qualisys.A = A;
