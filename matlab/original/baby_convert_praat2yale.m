function baby_convert_praat2yale(praatfile,xlsfilebase)
% BABY_CONVERT_PRAAT2YALE
%
%  Synopsis
%  ========
%
%  baby_convert_praat2yale(praatfile,xlsfilebase)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     February 2012
%
%  [1] Yale, et al. (2003), "The Temporal Coordination of Early Infant
%  Communication", Developmental Psychology, Vol. 39, No. 5, 815-824.
%
%  Purpose
%  =======
%  
%  Convert Praat txt files to Excel files for use with [1].
%
%  Inputs
%  ======


[varnames,A] = baby_load_praat(praatfile);

for varnum = 1:length(varnames)
  varname = varnames{varnum};
  seq = [round(A{varnum}{1}(:,1)*60) , A{varnum}{1}(:,3)];
  N = size(seq,1);
  xlsfilename = sprintf('%s_%s.csv',xlsfilebase,varname);
  fprintf('Writing %s\n',xlsfilename);
  xls = [zeros(N,1) ones(N,1) ones(N,1) seq(:,1) [seq(2:end,1)-1;seq(end,1)] seq(:,2)];
  csvwrite(xlsfilename,xls);
end
