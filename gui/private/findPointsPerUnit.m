function [nrPoints, avgValue] = findPointsPerUnit(startIdx,endIdx,pointsIdx, values)
% FINDPOINTSPERUNIT
%
% Finds the number and avg height of certain points per unit
% 
% Units are specified by startIdx and endIdx vector
% the point indices are given in pointsIdx
% value contains the corresponding values of the points
%
%   -- Author: Jan Bruemmerstedt --
%      Department of Psychology, University of Copenhagen, Denmark.
%      August 2013
%

nrUnits = length(startIdx);
% nr of points per unit
nrPoints = NaN(nrUnits,1); 

% average height of points per unit
avgValue = NaN(nrUnits,1);

for kk =1:nrUnits
  unitPointsIdx = find(startIdx(kk) <= pointsIdx & pointsIdx <= endIdx(kk));
nrPoints(kk)= length(unitPointsIdx);
avgValue(kk) = sum(values(pointsIdx(unitPointsIdx)))/nrPoints(kk);
end 