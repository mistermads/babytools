function [raw_c3d,markernames,units] = baby_load_c3d(c3dfile)
% BABY_LOAD_C3D
%
%  Synopsis
%  ========
%
%  [raw_c3d,markernames,units] = baby_load_c3d(c3dfile)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     August 2012
%
%  Purpose
%  =======
%  
%  Dependency
%  ==========
%
%  C3D directory from Skipper. But note that get3dtargets.m
%  was modified for æøå problem.

c3dobject = c3dserver();
openc3d(c3dobject,0,c3dfile);
raw_c3d = get3dtargets(c3dobject);
markernames = fieldnames(raw_c3d);
I = strmatch('units', markernames,'exact');
markernames(I) = [];
units = raw_c3d.units;
